//
//  ExpandedTaskTableViewCell.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 25/4/2023.
//

import UIKit

class ExpandedTaskTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource{
    
    
    var innerTableView: UITableView!
    var subTasks: [SubTask] = []
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)	
        innerTableView = UITableView(frame: .zero, style: .plain)
        innerTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(innerTableView)

        // Set constraints to pin the inner table view to the cell's contentView
        NSLayoutConstraint.activate([
            innerTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            innerTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            innerTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            innerTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        innerTableView.delegate = self
        innerTableView.dataSource = self

        // Register the inner table view cell class
        innerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubTaskCell")
        
        
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of subtasks for the task expanded
        return subTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //display all subtasks
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        let subtask = subTasks[indexPath.row]
        content.text = subtask.name
        cell.contentConfiguration = content
        return cell
    }
    
}


