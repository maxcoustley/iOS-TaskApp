//
//  DailyTaskTableViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import UIKit

class DailyTaskTableViewController: UITableViewController, DatabaseListener{
    let SECTION_TASK = 0;
    let CELL_TASK = "taskCell"
    var listenerType: ListenerType = .task
    var allTasks: [Tasks] = []
    var expandedRowIndex = -1
    var cells: [TaskTableViewCell] = []
    
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
        tableView.rowHeight = 44
        
        
    }
    
    func onTaskChange(change: DatabaseChange, tasks: [Tasks]) {
        allTasks = tasks
        for _ in 0..<allTasks.count {
            let cell = TaskTableViewCell()
            cells.append(cell)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_TASK {
            return allTasks.count
        }
        else {
            return 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == expandedRowIndex {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: "ExpandedTaskTableViewCell", for: indexPath) as! ExpandedTaskTableViewCell
            // Configure the expanded cell
            var content = taskCell.defaultContentConfiguration()
            let task = allTasks[indexPath.row]
            content.text = task.name
            taskCell.contentConfiguration = content
            
            return taskCell
        } else {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
            // Configure the main cell
            var content = taskCell.defaultContentConfiguration()
            let task = allTasks[indexPath.row]
            content.text = task.name
            taskCell.contentConfiguration = content
            
            taskCell.checkbox.isSelected = false
            
            taskCell.isExpanded = cells[indexPath.row].isExpanded
            
            return taskCell
            
        }
        
        
        
        
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
    
        
        if indexPath.row == expandedRowIndex {
            expandedRowIndex = -1 // Collapse the cell
        } else {
            expandedRowIndex = indexPath.row // Expand the cell
        }

        
        
        cells[indexPath.row].isExpanded.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == expandedRowIndex && cells[indexPath.row].isExpanded {
            // Return the expanded height
            return 200
        } else {
            // Return the collapsed height
            return 44
        }
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
