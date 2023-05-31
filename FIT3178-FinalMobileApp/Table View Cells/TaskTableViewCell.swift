//
//  TaskTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 25/4/2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    let checkbox = UIButton()
    var isExpanded = false
    var editButton: UIButton!
    var deleteButton: UIButton!
    weak var databaseController: DatabaseProtocol?
    weak var taskController: TaskProtocol?
    
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set up the checkbox
        checkbox.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        checkbox.setImage(UIImage(named: "checkbox-checked.png"), for: .selected)
        checkbox.setImage(UIImage(named: "checkbox-unchecked.png"), for: .normal)
        contentView.addSubview(checkbox)
        
        editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        editButton.isHidden = false
        editButton.clipsToBounds = false
        contentView.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Del", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteSection(_:)), for: .touchUpInside)
        contentView.addSubview(deleteButton)
        
        
        let taskAccessoryView = UIView(frame:   CGRect(x: 0, y: 0, width: 200, height: 44))
        let buttonPadding: CGFloat = 10
        let totalWidth = checkbox.frame.width + buttonPadding + editButton.frame.width
        checkbox.frame.origin = CGPoint(x: (taskAccessoryView.bounds.width - totalWidth) / 2, y: (taskAccessoryView.bounds.height - checkbox.frame.height) / 2)
        editButton.frame.origin = CGPoint(x: checkbox.frame.maxX + buttonPadding, y: (taskAccessoryView.bounds.height - editButton.frame.height) / 2)
        deleteButton.frame.origin = CGPoint(x: checkbox.frame.maxX + buttonPadding, y: (taskAccessoryView.bounds.height - editButton.frame.height) / 2)
        
        taskAccessoryView.addSubview(checkbox)
        taskAccessoryView.addSubview(editButton)
        taskAccessoryView.addSubview(deleteButton)
        
        accessoryView = taskAccessoryView
                                       
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        taskController = appDelegate?.taskController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(editButton)
        accessoryView = editButton
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the frame of the edit button
        let buttonWidth: CGFloat = 60.0
        let buttonHeight: CGFloat = 30.0
        let buttonX = contentView.frame.width - buttonWidth - 20.0
        let buttonY = (contentView.frame.height - buttonHeight) / 2.0
        editButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
    }
    
     @objc func editButtonTapped(_ sender: UIButton) {
//         let storyboard = UIStoryboard(name: "Main", bundle: nil)
//         let dailyTaskTableViewController = storyboard.instantiateViewController(withIdentifier: "DailyTaskTableViewController")
//         dailyTaskTableViewController.performSegue(withIdentifier: "editTaskSegue", sender: nil)
         //taskController?.didTapButtonInCell(self, button: sender)
     }
     
    
    
    @objc func checkboxTapped(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected
        checkbox.setImage(UIImage(named: isSelected ? "checkbox-checked.png" : "checkbox-unchecked.png"), for: .normal)
        
        guard let tableView = self.superview as? UITableView else {
            return
        }
        let button = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: button), let _ = tableView.cellForRow(at: indexPath) else {
                return
        }
        
        self.backgroundColor = UIColor.gray
        databaseController?.checkTask(taskRow: indexPath.row, newCheck: sender.isSelected)
    }
    
    @objc func deleteSection(_ sender: UIButton) {
    
        // Perform any necessary actions to delete the section data or update your data source
        
        guard let tableView = self.superview as? UITableView else {
            print("test1")
            return
        }
        let button = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: button) else {
            print("Test2")
            return
        }
        databaseController?.deleteTaskRow(taskRow: indexPath.row)
        print("test")
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
