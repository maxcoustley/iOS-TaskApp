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
        innerTableView = UITableView()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Set the subview's frame to fill the entire cell's contentView
        innerTableView.frame = contentView.bounds
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Set the cell's height to accommodate the subview
        let subviewHeight = innerTableView.contentSize.height
        return CGSize(width: size.width, height: subviewHeight)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of subtasks for the task expanded
        return subTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //display all subtasks
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let subtask = subTasks[indexPath.row]
        content.text = subtask.name
        cell.contentConfiguration = content
        return cell
    }
    
}


