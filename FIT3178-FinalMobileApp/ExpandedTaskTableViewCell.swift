//
//  ExpandedTaskTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 25/4/2023.
//

import UIKit

class ExpandedTaskTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Add the edit button to the cell's content view
       
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


