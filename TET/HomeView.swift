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
    @IBOutlet weak var currentTrip: UIButton!
    @IBOutlet weak var pastTrip: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitle.text = "Travel Expense Tracker"
    }

    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "currentTrip") as? Data {
            curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
            //If empty trip
            if curTrip.tripName == "Untitled Trip" && curTrip.expensesLog.count == 0 {
                currentTrip.setTitle("New Trip", for: .normal)
            } else {
                currentTrip.setTitle("Current Trip", for: .normal)
                if isInitialLaunch == "Yes" {
                    self.view.isHidden = true
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toCurTrip", sender: self)
                    }
                }
            }
        } else {
            currentTrip.setTitle("New Trip", for: .normal)
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



