//
//  EditableTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 11/5/2023.
//

import UIKit

class EditableTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var subtaskTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

