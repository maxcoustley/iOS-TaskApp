//
//  AddTaskViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import UIKit

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var nameTextField: UITextField!
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var subtaskName: UITextField!
    @IBOutlet weak var subTaskTableView: UITableView!
    var subtasks: [SubTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        subTaskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "addSubTaskCell")
        subTaskTableView.dataSource = self
        subTaskTableView.delegate = self
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
        handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func swipeRightGesture(_ sender: Any) {
        guard let name = subtaskName.text
        else {
            return
        }
        if name.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
                if name.isEmpty {
                    errorMsg += "- Must provide a name\n"
                }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        else {
            let subtask = SubTask()
            subtask.name = name
            subtask.check = false
            subtasks.append(subtask)
            subTaskTableView.reloadData()
        }
    }
    
    @IBAction func createTask(_ sender: Any) {
        guard let name = nameTextField.text
        else {
            return
        }
        if name.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
                if name.isEmpty {
                    errorMsg += "- Must provide a name\n"
                }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        else{
            let _ = databaseController?.addTask(name: name, check: false, subtasks: subtasks)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addSubtask(_ sender: Any) {
        // Adds subtask to task
        guard let name = subtaskName.text
        else {
            return
        }
        if name.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
                if name.isEmpty {
                    errorMsg += "- Must provide a name\n"
                }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        else {
            let subtask = SubTask()
            subtask.name = name
            subtask.check = false
            subtasks.append(subtask)
            subTaskTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // Delete the row from the data source
            subtasks.remove(at: indexPath.row)
            subTaskTableView.reloadData()
            //addSubtask db controller
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Displays any subtasks that have been created
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSubTaskCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let subtask = subtasks[indexPath.row]
        content.text = subtask.name
        cell.contentConfiguration = content
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
