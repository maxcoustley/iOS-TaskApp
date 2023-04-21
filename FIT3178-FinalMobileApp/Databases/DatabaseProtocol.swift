//
//  DatabaseProtocol.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import Foundation

//
//  DatabaseProtocol.swift
//  FIT3178-W03-Lab
//
//  Created by Max Coustley on 24/3/2023.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update

}
enum ListenerType {
    case task
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTaskChange(change: DatabaseChange, tasks: [Tasks])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addTask(name: String) -> Tasks
    func deleteTask(task: Tasks)
    
}
