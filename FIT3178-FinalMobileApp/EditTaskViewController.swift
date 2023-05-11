//
//  EditTaskViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 4/5/2023.
//

import UIKit

class EditTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var databaseController: DatabaseProtocol?
    var taskEditing: DailyTask!
    
    @IBOutlet weak var subTaskTableView: UITableView!
    @IBOutlet weak var taskName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        taskName.text = taskEditing.name
        subTaskTableView.register(EditableTableViewCell.self, forCellReuseIdentifier: "editSubTaskCell")
        subTaskTableView.dataSource = self
        subTaskTableView.delegate = self
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    @IBAction func editTask(_ sender: UIButton) {
        guard let name = taskName.text
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
            let _ = databaseController?.editTask(name: name, check: false, subtasks: taskEditing.subtasks, editedTask: taskEditing)
            navigationController?.popViewController(animated: true)
        }
    }

    
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
        handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskEditing.subtasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editSubTaskCell", for: indexPath) as! EditableTableViewCell
        let subtask = taskEditing.subtasks[indexPath.row]
        if cell.subtaskTextField == nil {
            print(subtask.name)
            return cell
        }
        else {
            print(subtask.name)
            cell.subtaskTextField.text = subtask.name
            return cell
        }
        
    }
}

