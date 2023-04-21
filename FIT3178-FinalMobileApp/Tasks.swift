//
//  Tasks.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

class Tasks: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var subtasks: [String] = []
    
}
