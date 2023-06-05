//
//  TaskStreakViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 18/5/2023.
//

import UIKit
import Foundation

class TaskStreakViewController: UIViewController {

    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var currentStreak: UILabel!
    
    @IBOutlet weak var highestStreak: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        //Set values for streaks
        if let highest = defaults.object(forKey: "highest") as? Int {
            highestStreak.text = String(highest)
        }
        else {
            highestStreak.text = "0"
        }
        if let current = defaults.object(forKey: "current") as? Int{
            currentStreak.text = String(current)
        }
        else {
            currentStreak.text = "0"
        }

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
