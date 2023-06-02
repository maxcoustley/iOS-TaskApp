//
//  TaskTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 25/4/2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
   
    weak var databaseController: DatabaseProtocol?
    weak var taskController: TaskProtocol?
    
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set up the checkbox
       
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        taskController = appDelegate?.taskController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
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
