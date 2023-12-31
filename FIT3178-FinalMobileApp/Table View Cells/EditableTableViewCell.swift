//
//  EditableTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 11/5/2023.
//

import UIKit

class EditableTableViewCell: UITableViewCell {
    
    var editedTask: SubTask!
    @IBOutlet weak var subtaskTextField: UITextField!
    var textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

