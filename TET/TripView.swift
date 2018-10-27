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

    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var endOrMC: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var transportationRow: TypeRow!
    @IBOutlet weak var livingRow: TypeRow!
    @IBOutlet weak var eatingRow: TypeRow!
    @IBOutlet weak var entertainmentRow: TypeRow!
    @IBOutlet weak var souvenirRow: TypeRow!
    @IBOutlet weak var otherRow: TypeRow!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
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
    
    var typeSender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        totalAmountLabel.adjustsFontSizeToFitWidth = true
        
        transportationRow.typeLabel.text = "Transportation Cost"
        transportationRow.plusButton.type = "Transportation"
        transportationRow.plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        livingRow.typeLabel.text = "Living Cost"
        livingRow.plusButton.type = "Living"
        livingRow.plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        eatingRow.typeLabel.text = "Eating Cost"
        eatingRow.plusButton.type = "Eating"
        eatingRow.plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        entertainmentRow.typeLabel.text = "Entertainment Cost"
        entertainmentRow.plusButton.type = "Entertainment"
        entertainmentRow.plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        souvenirRow.typeLabel.text = "Souvenir Cost"
        souvenirRow.plusButton.type = "Souvenir"
        souvenirRow.plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        otherRow.typeLabel.text = "Other Cost"
        otherRow.plusButton.type = "Other"
        otherRow.plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabcont = self.tabBarController as? TabVC
        displayPastTrip = tabcont.displayPastTrip
        
        if displayPastTrip == "Yes" {
            endOrMC.setTitle("Make Current", for: .normal)
            if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
                pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
            }
            whichPastTrip = UserDefaults.standard.integer(forKey: "whichPastTrip")
            curTrip = pastTrips[whichPastTrip]
        }
        else {
            endOrMC.setTitle("End Trip", for: .normal)
            if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
                curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
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
        
        transportationRow.amountLabel.text = "$" + String(format: "%.2f", tranA)
        livingRow.amountLabel.text = "$" + String(format: "%.2f", livingA)
        eatingRow.amountLabel.text = "$" + String(format: "%.2f", eatingA)
        entertainmentRow.amountLabel.text = "$" + String(format: "%.2f", entA)
        souvenirRow.amountLabel.text = "$" + String(format: "%.2f", souvA)
        otherRow.amountLabel.text = "$" + String(format: "%.2f", otherA)
        totalAmountLabel.text = "$" + String(format: "%.2f", totalA)
    }
    
    func loopThroughExpenses(expenses: [SingleExpense]) {
        for i in 0..<expenses.count {
            let aString: String! = expenses[i].amount
            let amount: Double! = Double(aString.substring(from: aString.index(aString.startIndex, offsetBy: 1)))
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
    
    @objc func plusButtonPressed(sender: PlusButton) {
        typeSender = sender.type
        performSegue(withIdentifier: "toNewExpense", sender: self)
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
            curTrip.endDate = getCurrentDate()
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
            curTrip.endDate = "Present"
            pastTrips.remove(at: whichPastTrip)
            
            let decoded = UserDefaults.standard.object(forKey: "currentTrip") as! Data
            let prevCurrent: Trip! = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
            
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
        } else if segue.identifier == "toNewExpense" {
            let upcoming: NewExpense = segue.destination as! NewExpense
            upcoming.displayPastTrip = displayPastTrip
            upcoming.type = typeSender
        } else if segue.identifier == "toHomefromTrip" {
            let upcoming: HomeView = segue.destination as! HomeView
            upcoming.isInitialLaunch = "No"
        }
    }
    
    //Current date in Jan 1, 2018 form
    func getCurrentDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year_now = String(calendar.component(.year, from: date))
        let month_now = changeMonthToString(mon: calendar.component(.month, from: date))
        let day_now = String(calendar.component(.day, from: date))
        return month_now + " " + day_now + ", " + year_now
    }
    
    func changeMonthToString(mon: Int) -> String {
        switch mon {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }

}
