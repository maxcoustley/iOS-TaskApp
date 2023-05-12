//
//  SubTask.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 11/5/2023.
//

import UIKit
import FirebaseFirestoreSwift

class SubTask: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var check: Bool?
    
    init(id: String? = nil, name: String? = nil, check: Bool? = nil) {
        self.id = id
        self.name = name
        self.check = check
    }
}
