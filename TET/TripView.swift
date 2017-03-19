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
    @IBOutlet weak var categoryAmounts: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var tranA: Double!
    var livingA: Double!
    var eatingA: Double!
    var entA: Double!
    var souvA: Double!
    var otherA: Double!
    var totalA: Double!
    
    var tranC: String!
    var livingC: String!
    var eatingC: String!
    var entC: String!
    var souvC: String!
    var otherC: String!
    var totalC: String!
    
    var displayPastTrip: String!
    var whichPastTrip: Int!
    var tabcont: TabVC!
    var pastTrips: [Trip] = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabcont = self.tabBarController as! TabVC
        displayPastTrip = tabcont.displayPastTrip
        
        if displayPastTrip == "Yes" {
            endOrMC.setTitle("Make Current Trip", for: .normal)
            if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
                pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
            }
            whichPastTrip = UserDefaults.standard.integer(forKey: "whichPastTrip")
            curTrip = pastTrips[whichPastTrip]
        }
        else {
            endOrMC.setTitle("End Trip", for: .normal)
            if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
                curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
            }
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
        tranC = "$" + String(format: "%.2f", tranA)
        livingC = "$" + String(format: "%.2f", livingA)
        eatingC = "$" + String(format: "%.2f", eatingA)
        entC = "$" + String(format: "%.2f", entA)
        souvC = "$" + String(format: "%.2f", souvA)
        otherC = "$" + String(format: "%.2f", otherA)
        totalC = "$" + String(format: "%.2f", totalA)
        categoryAmounts.text = tranC + "\n\n" + livingC + "\n\n" + eatingC + "\n\n" + entC + "\n\n" + souvC + "\n\n" + otherC + "\n\n\n" + totalC
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
        if displayPastTrip == "Yes" {
            pastTrips.remove(at: whichPastTrip)
            pastTrips.insert(curTrip, at: whichPastTrip)
            let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: pastTrips)
            userDefaults.set(encodedPT, forKey: "pastTrips")
        } else {
            let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
            userDefaults.set(encoded, forKey: "currentTrip")
        }
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
            
            if prevCurrent.tripName != "Untitled Trip" || prevCurrent.expensesLog.count != 0 {
                pastTrips.append(prevCurrent)
            }
            let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: pastTrips)
            userDefaults.set(encodedPT, forKey: "pastTrips")
            
            let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
            userDefaults.set(encoded, forKey: "currentTrip")
            userDefaults.synchronize()
            
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
        } else if segue.identifier == "toNewExpense" {
            let upcoming: NewExpense = segue.destination as! NewExpense
            upcoming.displayPastTrip = displayPastTrip
            //upcoming.curTrip = curTrip
        }
    }

}
