//
//  FirebaseController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth


class FirebaseController: NSObject, DatabaseProtocol {
    
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var tasksRef: CollectionReference?
    var streakRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    var taskList: [DailyTask] = []
    
    override init(){
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        taskList = [DailyTask]()
        super.init()
        
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user
            }
            catch {
                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
            }
            self.setupTaskListener()
        }
    }
    
    func cleanup() {
        
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .task || listener.listenerType == .all {
            listener.onTaskChange(change: .update, tasks: taskList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addTask(name: String, check: Bool, subtasks: [SubTask]) -> DailyTask {
        let task = DailyTask()
        task.name = name
        task.check = check
        task.subtasks = subtasks
        do {
            if let taskRef = try tasksRef?.addDocument(from: task) {
                task.id = taskRef.documentID
                
            }
        } catch {
            print("Failed to serialize task")
        }
        return task
    }
    
    func editTask(name: String, check: Bool, subtasks: [SubTask], editedTask: DailyTask){
        let subtaskDict = subtasks.map { subtask in
            return [
                "name": subtask.name,
                "check": subtask.check
            ]
        }
        if let taskID = editedTask.id {
            tasksRef?.document(taskID).updateData(["name": name, "check": check, "subtasks": subtaskDict])
        }
    }
    
    func checkTask(taskRow: Int, newCheck: Bool) {
        let task = taskList[taskRow]
        task.check = newCheck
        if let taskID = task.id {
            tasksRef?.document(taskID).updateData(["check": newCheck])
        }
    }
    
    func checkSubtask(taskSection: Int, taskRow: Int, newCheck: Bool) {
        
        let task = taskList[taskSection]
        let subtasks = task.subtasks
        subtasks[taskRow].check = newCheck
        
        //create array of maps to use to update new subtask values
        let subtaskDict = subtasks.map { subtask in
            return [
                "name": subtask.name,
                "check": subtask.check
            ]
        }
        if let taskID = task.id {
            tasksRef?.document(taskID).updateData(["name": task.name, "check": task.check, "subtasks": subtaskDict])
        }
    }
    
    func deleteTask(task: DailyTask) {
        if let taskID = task.id {
            tasksRef?.document(taskID).delete()
        }
    }
    
    //deletes task using indexPath.row value rather than task itself
    func deleteTaskRow(taskRow: Int) {
        let task = taskList[taskRow]
        if let taskID = task.id {
            tasksRef?.document(taskID).delete()
        }
    }
    
    func deleteSubtask(subtask: SubTask, task: DailyTask, taskRow: Int) {
        task.subtasks.remove(at: taskRow)
        let newSubtasks = task.subtasks
        if let taskID = task.id {
            tasksRef?.document(taskID).updateData(["name": task.name, "check": task.check, "subtasks": newSubtasks])
        }
    }
    
    func setupTaskListener() {
        tasksRef = database.collection("tasks")
        
        tasksRef?.addSnapshotListener(){
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseTasksSnapshot(snapshot:querySnapshot)
        }
    }
    
    func parseTasksSnapshot(snapshot: QuerySnapshot){
        snapshot.documentChanges.forEach { (change) in
            var parsedTask: DailyTask?
            do {
                parsedTask = try change.document.data(as: DailyTask.self)
            } catch {
                print("Unable to decode task. Is the task malformed? \(error)")
                return
            }
            guard let task = parsedTask else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                taskList.insert(task, at: Int(taskList.count))
            }
            else if change.type == .modified {
                if Int(change.oldIndex) < taskList.count{
                    taskList[Int(change.oldIndex)] = task
                }
                else {
                    taskList[taskList.count-1] = task
                }
                
            }
            else if change.type == .removed {
                taskList.remove(at: Int(change.oldIndex))
            }
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.task || listener.listenerType == ListenerType.all {
                    listener.onTaskChange(change: .update, tasks: taskList)
                }
            }
        }
    }
    
    
    
}
