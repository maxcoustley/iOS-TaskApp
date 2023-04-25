//
//  TaskTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 25/4/2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    let checkbox = UIButton()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set up the checkbox
        checkbox.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        checkbox.setImage(UIImage(named: "checkbox-checked.png"), for: .selected)
        checkbox.setImage(UIImage(named: "checkbox-unchecked.png"), for: .normal)
        
        accessoryView = checkbox
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkbox.setImage(UIImage(named: isSelected ? "checkbox-checked.png" : "checkbox-unchecked.png"), for: .normal)
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
