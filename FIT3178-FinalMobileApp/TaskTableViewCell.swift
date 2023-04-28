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
    
    weak var databaseController: DatabaseProtocol?
    
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set up the checkbox
        checkbox.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        checkbox.setImage(UIImage(named: "checkbox-checked.png"), for: .selected)
        checkbox.setImage(UIImage(named: "checkbox-unchecked.png"), for: .normal)
        
        accessoryView = checkbox
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkbox.setImage(UIImage(named: isSelected ? "checkbox-checked.png" : "checkbox-unchecked.png"), for: .normal)
        guard let tableView = self.superview as? UITableView else {
            return
        }
        let buttonOrigin = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: buttonOrigin), let cell = tableView.cellForRow(at: indexPath) else {
                return
        }
        let row = indexPath.row
        databaseController?.checkTask(taskRow: row, newCheck: sender.isSelected)
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
