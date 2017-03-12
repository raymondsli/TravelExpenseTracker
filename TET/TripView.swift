//
//  TripView.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class TripView: UIViewController, UITextFieldDelegate {
    var curTrip: Trip!
    
    @IBOutlet weak var newExpense: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var endOrMC: UIButton!
    
    @IBOutlet weak var typeLabels: UILabel!
    @IBOutlet weak var tranC: UILabel!
    @IBOutlet weak var livingC: UILabel!
    @IBOutlet weak var eatingC: UILabel!
    @IBOutlet weak var entC: UILabel!
    @IBOutlet weak var souvC: UILabel!
    @IBOutlet weak var otherC: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var tranA: Double!
    var livingA: Double!
    var eatingA: Double!
    var entA: Double!
    var souvA: Double!
    var otherA: Double!
    var totalA: Double!
    
    var displayPastTrip: String!
    var whichPastTrip: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabcont: TabVC = self.tabBarController as! TabVC
        displayPastTrip = tabcont.displayPastTrip
        whichPastTrip = tabcont.whichPastTrip
        
        if displayPastTrip != "Yes" {
            endOrMC.setTitle("End Trip", for: .normal)
            if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
                curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
            }
        } else {
            endOrMC.setTitle("Make Current Trip", for: .normal)
            newExpense.isHidden = true
            curTrip = tabcont.curTrip
        }
        tranA = 0.00
        livingA = 0.00
        eatingA = 0.00
        entA = 0.00
        souvA = 0.00
        otherA = 0.00
        totalA = 0.00
        loopThroughExpenses(expenses: curTrip.expensesLog)
        
        nameTextField.text = curTrip.tripName
        tranC.text = "$" + String(tranA)
        livingC.text = "$" + String(livingA)
        eatingC.text = "$" + String(eatingA)
        entC.text = "$" + String(entA)
        souvC.text = "$" + String(souvA)
        otherC.text = "$" + String(otherA)
        totalCost.text = "$" + String(totalA)
    }
    
    func loopThroughExpenses(expenses: [SingleExpense]) {
        for i in 0..<expenses.count {
            let aString: String! = expenses[i].amount
            let amount: Double! = Double(aString.substring(from: aString.characters.index(aString.startIndex, offsetBy: 1)))
            let type: String! = expenses[i].type
            
            if type == "Transportation" {
                tranA = tranA + amount
            } else if type == "Living" {
                livingA = livingA + amount
            } else if type == "Eating" {
                eatingA = eatingA + amount
            } else if type == "Entertainment" {
                entA = entA + amount
            } else if type == "Souvenir" {
                souvA = souvA + amount
            } else if type == "Other" {
                otherA = otherA + amount
            }
            totalA = totalA + amount
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.text = textField.text
        curTrip.tripName = textField.text
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
        userDefaults.set(encodedData, forKey: "currentTrip")
        userDefaults.synchronize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func newExpense(_ sender: Any) {
        performSegue(withIdentifier: "toNewExpense", sender: self)
    }
    
    @IBAction func back(_ sender: Any) {
        if displayPastTrip != "Yes" {
            performSegue(withIdentifier: "toHomefromTrip", sender: self)
        } else {
            performSegue(withIdentifier: "toPastfromTrip", sender: self)
        }
    }

    @IBAction func endOrMC(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        var pastTrips: [Trip] = [Trip]()
        if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
            pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
        }
        if displayPastTrip != "Yes" {
            //End Trip
            pastTrips.append(curTrip)
            
            let freshTrip: Trip! = Trip()
            let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: freshTrip)
            userDefaults.set(encoded, forKey: "currentTrip")
            
            let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: pastTrips)
            userDefaults.set(encodedPT, forKey: "pastTrips")
            userDefaults.synchronize()
            
            performSegue(withIdentifier: "endedTrip", sender: self)
        } else {
            //Make Current Trip
            pastTrips.remove(at: whichPastTrip)
            
            let decoded = UserDefaults.standard.object(forKey: "currentTrip") as! Data
            let prevCurrent: Trip! = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
            
            if prevCurrent.tripName != "UntitledTrip" || prevCurrent.totalCost != 0.0 {
                let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: pastTrips)
                pastTrips.append(prevCurrent)
                userDefaults.set(encodedPT, forKey: "pastTrips")
                userDefaults.synchronize()
            }
            
            let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
            userDefaults.set(encoded, forKey: "currentTrip")
        
            
            performSegue(withIdentifier: "makeCurrent", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeCurrent" {
            let upcoming: TabVC = segue.destination as! TabVC
            upcoming.displayPastTrip = "No"
            upcoming.curTrip = curTrip
        } else if segue.identifier == "endedTrip" {
            //let upcoming: PastTrips = segue.destination as! PastTrips
        }
    }

}
