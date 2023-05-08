//
//  TaskProtocol.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 8/5/2023.
//

import Foundation
import UIKit

protocol TaskProtocol: AnyObject {
    func didTapButtonInCell(_ cell: TaskTableViewCell, button: UIButton)
    func checkboxTap(_ cell: TaskTableViewCell)
}
