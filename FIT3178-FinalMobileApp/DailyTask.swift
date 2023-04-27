//
//  Tasks.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 21/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

class DailyTask: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var check: Bool?
    //var subtasks: [String] = []
    
}
    
