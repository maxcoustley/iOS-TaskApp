//
//  TaskStreakViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 18/5/2023.
//

import UIKit

class TaskStreakViewController: UIViewController {

    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var currentStreak: UILabel!
    
    @IBOutlet weak var highestStreak: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        retrieveCurrentStreak(completion: handleCurrentStreakResult)
        retrieveHighestStreak(completion: handleHighestStreakResult)

    
    }
    
    func retrieveHighestStreak(completion: @escaping (Int?, Error?) -> Void) {
        Task {
            do {
                let highest = try await (databaseController?.fetchHighestStreak())!
                completion(highest, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func handleHighestStreakResult(highest: Int?, error: Error?) {
        if let highest = highest {
            highestStreak.text = String(highest)
            highestStreak.accessibilityLabel = "Highest streak is \(String(highest))"
        } else if let error = error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func retrieveCurrentStreak(completion: @escaping (Int?, Error?) -> Void) {
        Task {
            do {
                let current = try await (databaseController?.fetchCurrentStreak())!
                completion(current, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func handleCurrentStreakResult(current: Int?, error: Error?) {
        if let current = current {
            currentStreak.text = String(current)
            currentStreak.accessibilityLabel = "Current streak is \(String(current))"
        } else if let error = error {
            print("Error: \(error.localizedDescription)")
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
