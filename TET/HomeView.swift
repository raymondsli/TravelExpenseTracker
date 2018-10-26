//
//  HomeView.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class HomeView: UIViewController {

    var curTrip: Trip!
    var isInitialLaunch: String! = "Yes"
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var currentTripButton: UIButton!
    @IBOutlet weak var pastTripButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitle.text = "Travel Expense Tracker"
        appTitle.adjustsFontSizeToFitWidth = true
    }

    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "currentTrip") as? Data {
            curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
            
            if curTrip.tripName == "Untitled Trip" && curTrip.expensesLog.count == 0 {
                currentTripButton.setTitle("New Trip", for: .normal)
            } else {
                currentTripButton.setTitle("Current Trip", for: .normal)
                if isInitialLaunch == "Yes" {
                    self.view.isHidden = true
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toCurTrip", sender: self)
                    }
                }
            }
        } else {
            currentTripButton.setTitle("New Trip", for: .normal)
            curTrip = Trip()
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
            userDefaults.set(encodedData, forKey: "currentTrip")
            userDefaults.synchronize()
        }
    }
    
    
    @IBAction func toTab(_ sender: Any) {
        performSegue(withIdentifier: "toCurTrip", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurTrip" {
            let upcoming: TabVC = segue.destination as! TabVC
            
            upcoming.displayPastTrip = "No"
            upcoming.curTrip = curTrip
        }
    }
}



