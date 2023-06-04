//
//  DatabaseProtocol.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import Foundation

//
//  DatabaseProtocol.swift
//  FIT3178-W03-Lab
//
//  Created by Max Coustley on 24/3/2023.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update

}
enum ListenerType {
    case task
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTaskChange(change: DatabaseChange, tasks: [DailyTask])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addTask(name: String, check: Bool, subtasks: [SubTask]) -> DailyTask
    func editTask(name: String, check: Bool, subtasks: [SubTask], editedTask: DailyTask)
    func deleteTask(task: DailyTask)
    func deleteTaskRow(taskRow: Int)
    func checkTask(taskRow: Int, newCheck: Bool)
    func checkSubtask(taskSection: Int, taskRow: Int, newCheck: Bool)
    func deleteSubtask(subtask: SubTask, task: DailyTask, taskRow: Int)
    
}
