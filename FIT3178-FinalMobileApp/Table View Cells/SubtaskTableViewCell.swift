//
//  SubtaskTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 15/5/2023.
//

import UIKit

class SubtaskTableViewCell: UITableViewCell {

    let checkbox = UIButton()
    var isExpanded = false
    var editButton: UIButton!
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
        
        accessoryView = checkbox
                                       
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        taskController = appDelegate?.taskController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the frame of the edit button
        
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
