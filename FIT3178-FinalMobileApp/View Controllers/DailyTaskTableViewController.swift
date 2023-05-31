//
//  DailyTaskTableViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import UIKit
import MobileCoreServices
import UserNotifications
import Foundation

class DailyTaskTableViewController: UITableViewController, DatabaseListener, UITableViewDragDelegate{
    
    
    let SECTION_TASK = 0;
    let CELL_TASK = "taskCell"
    var listenerType: ListenerType = .task
    var allTasks: [DailyTask] = []
    var expandedRowIndex = -1
    var cells: [TaskTableViewCell] = []
    var checkbox = false
    var checkedTask: TaskTableViewCell?
    var editButton: UIButton!
    var deleteButton: UIButton!
    var taskEditing: DailyTask!
    var isSectionExpanded: [Bool] = []
    var tasksCompleted: Bool = false
    var currentStreak = 0
    var highestStreak = 0
    
    
    
    weak var databaseController: DatabaseProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.register(ExpandedTaskTableViewCell.self, forCellReuseIdentifier: "ExpandedTaskTableViewCell")
        tableView.register(SubtaskTableViewCell.self, forCellReuseIdentifier: "SubtaskTableViewCell")

        
        tableView.rowHeight = 44
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.scheduleNotification()
            }
        }
        
        dailyCheck()
        
        
        
    }
    
    func scheduleNotification() {
        // Create content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "This is your daily reminder."
        content.sound = .default
        
        // Create a trigger for the notification
//        var dateComponents = DateComponents()
//        dateComponents.hour = 12
//        dateComponents.minute = 00
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Create a request for the notification
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func checkTasksCompleted() -> Bool {
        for i in 0..<allTasks.count {
            if allTasks[i].check == false {
                return false
            }
        }
        return true
    }
    
    func updateStreak() {
        if checkTasksCompleted() {
            currentStreak += 1
            
            if currentStreak > highestStreak {
                highestStreak = currentStreak
            }
        } else {
            currentStreak = 0
        }
        let defaults = UserDefaults.standard
        defaults.set(highestStreak, forKey: "highest")
        defaults.set(currentStreak, forKey: "current")
    }
    
    func dailyCheck() {
        let calendar = Calendar.current
        let now = Date()
        
        let endOfDayComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: calendar.date(from: endOfDayComponents)!)
            
            // Calculate the time interval until the end of the day
            let timeInterval = endOfDay!.timeIntervalSince(now)
            
            // Schedule the timer to trigger at the end of the day
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
                self.updateStreak()
                
                // Schedule the check again for the next day
                self.dailyCheck()
            }
    }
    
    func onTaskChange(change: DatabaseChange, tasks: [DailyTask]) {
        allTasks = tasks
        for _ in 0..<allTasks.count {
            let cell = TaskTableViewCell()
            cells.append(cell)
        }
        if isSectionExpanded.count != allTasks.count {
            for _ in 0..<allTasks.count {
                isSectionExpanded.append(false)
            }
        }

        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return allTasks.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isSectionExpanded[section] ? allTasks[section].subtasks.count : 0
    }
    
    override func  tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        taskEditing = allTasks[indexPath.row]
        performSegue(withIdentifier: "editTaskSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        if allTasks[section].check == true{
            
//            editButton.isHidden = true
//            let mover = allTasks.remove(at: section)
//            let numberOfRows = tableView.numberOfRows(inSection: section)
//            let lastIndexPath = IndexPath(row: numberOfRows - 1, section: section)
//
//            allTasks.insert(mover, at: lastIndexPath.row)
            cell.backgroundColor = UIColor.lightGray
            cell.checkbox.isSelected = true
                        
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.checkbox.isSelected = false
//            cell.editButton.isHidden = false
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.tag = section
        var content = cell.defaultContentConfiguration()
        content.text = allTasks[section].name
        cell.contentConfiguration = content
        
        editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        editButton.isHidden = false
        editButton.clipsToBounds = false
        editButton.tag = section
        cell.contentView.addSubview(editButton)

        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            editButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])

        cell.accessoryView?.addSubview(editButton)
        
        deleteButton = UIButton(type: .system)
        deleteButton.frame = CGRect(x: 130, y: 0, width: 50, height: 30)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteSection(_:)), for: .touchUpInside)
        deleteButton.tag = section
        cell.accessoryView?.addSubview(deleteButton)
        
        return cell
    }
    
    @objc func deleteSection(_ sender: UIButton) {
        let section = sender.tag
        // Perform any necessary actions to delete the section data or update your data source
        
        // Remove the section from the table view
        databaseController?.deleteTaskRow(taskRow: section)
        
        //remove task from database
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        let x = isSectionExpanded[section]
        isSectionExpanded.removeAll()
        for _ in 0..<allTasks.count {
            isSectionExpanded.append(false)
        }
        isSectionExpanded[section] = !x // Toggle expanded/collapsed state
        let indexSet = IndexSet(integer: section)
        if allTasks[section].subtasks.count == 0 {
            displayMessage(title: "No subtasks", message: "There are no subtasks for this task")
        }
        tableView.reloadData()
        //tableView.reloadSections(indexSet, with: .automatic) // Update table view display
   }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtaskTableViewCell")
//        var content = cell?.defaultContentConfiguration()
//        content?.text = allTasks[indexPath.section].subtasks[indexPath.row].name
//        cell?.contentConfiguration = content
//        return cell!
    
//        if indexPath.row == expandedRowIndex {
//            let taskCell = tableView.dequeueReusableCell(withIdentifier: "ExpandedTaskTableViewCell", for: indexPath) as! ExpandedTaskTableViewCell
//            // Configure the expanded cell
//            var content = taskCell.defaultContentConfiguration()
//            let task = allTasks[indexPath.row]
//            taskCell.subTasks = task.subtasks
//            taskCell.innerTableView.reloadData()
//            //create subtask table view controller
//            //fetch subtasks and place into table view
//
//            taskCell.contentConfiguration = content
//
//
//            return taskCell
//        } else {
        
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "SubtaskTableViewCell", for: indexPath) as! SubtaskTableViewCell
        // Configure the main cell
        
        //return subtask cell
        //create subtask cell class + maybe get rid of expanded view cell class
        //clicking on task cell will expand the subtask cells
        
        if allTasks[indexPath.section].subtasks[indexPath.row].check == true {
            let mover = allTasks.remove(at: indexPath.row)
            let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
            let lastIndexPath = IndexPath(row: numberOfRows - 1, section: indexPath.section)

            allTasks.insert(mover, at: lastIndexPath.row)
            taskCell.backgroundColor = UIColor.gray
        }
        else {
            taskCell.backgroundColor = UIColor.white
        }
        var content = taskCell.defaultContentConfiguration()
        let task = allTasks[indexPath.section].subtasks[indexPath.row]
        content.text = task.name
        taskCell.contentConfiguration = content

        taskCell.checkbox.isSelected = task.check ?? false
    


        //taskCell.isExpanded = cells[indexPath.row].isExpanded

       

        return taskCell
            
        
        
    }	
    
    @objc func editButtonTapped(_ sender: UIButton) {
        let buttonPath = editButton.tag
        
        taskEditing = allTasks[buttonPath]
        performSegue(withIdentifier: "editTaskSegue", sender: sender)
        
        
    }
    
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == SECTION_TASK {
            return true
        }
        else {
            return false
        }
    }
   

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_TASK {
            // Delete the row from the data source
            let task = allTasks[indexPath.row]
            databaseController?.deleteTask(task: task)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
//        if indexPath.row == expandedRowIndex {
//            expandedRowIndex = -1 // Collapse the cell
//        } else {
//            expandedRowIndex = indexPath.row // Expand the cell
//        }
//
//
//
//        cells[indexPath.row].isExpanded.toggle()
//
//        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == expandedRowIndex && cells[indexPath.row].isExpanded {
//            // Return the expanded height
//            return 200
//        } else {
//            // Return the collapsed height
//            return 44
//        }
        return 44
    }
    

    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
        handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
   
    // MARK: - UITableViewDragDelegate
    
     func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
         let cell = tableView.cellForRow(at: indexPath)!
         let task = allTasks[indexPath.row]
         if let text = task.name {
             let itemProvider = NSItemProvider(object: text as NSString)
             let dragItem = UIDragItem(itemProvider: itemProvider)
             return [dragItem]
         } else {
             // handle the case where the cell's textLabel is nil
             return []
         }
     }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = allTasks.remove(at: sourceIndexPath.row)
        allTasks.insert(mover, at: destinationIndexPath.row)
        tableView.reloadData()
        
    }
     
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editTaskSegue" {
            if let destinationVC = segue.destination as? EditTaskViewController {
                destinationVC.taskEditing = taskEditing
            }
        }
        
    }
    


}

extension DailyTaskTableViewController: TaskProtocol {
    func didTapButtonInCell(_ cell: TaskTableViewCell, button: UIButton) {
        self.performSegue(withIdentifier: "editTaskSegue", sender: button)
    }
    
    func checkboxTap(_ cell: TaskTableViewCell) {
        
        checkbox = true
        checkedTask = cell
        tableView.reloadData()
    }
}
