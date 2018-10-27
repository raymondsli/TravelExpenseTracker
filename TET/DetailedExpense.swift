//
//  DetailedExpense.swift
//  TET
//
//  Created by Raymond Li on 12/26/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class DetailedExpense: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var expenseTitle: UITextView!
    @IBOutlet weak var expenseComment: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    var titleT: String!
    var comment: String!
    var dateT: String!
    var typeT: String!
    var amountT: String!
    var currentExpenseRow: Int!
    
    var displayPastTrip: String!
    var curTrip: Trip!
    var pastTrips: [Trip] = [Trip]()
    var whichPastTrip: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseComment.delegate = self
        expenseTitle.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expenseTitle.text = titleT
        expenseComment.text = comment
        date.text = dateT
        type.text = typeT
        amount.text = amountT
        
        if displayPastTrip == "Yes" {
            if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
                pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
            }
            whichPastTrip = UserDefaults.standard.integer(forKey: "whichPastTrip")
            curTrip = pastTrips[whichPastTrip]
        } else {
            let decoded = UserDefaults.standard.object(forKey: "currentTrip") as! Data
            curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 {
            return true
        }
        //Prevent multiple lines title
        if text == "\n" {
            textView.resignFirstResponder()
        }
        //Limit title to 22 characters
        if let x = textView.text {
            let length = x.characters.count + text.characters.count
            if length <= 22 {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        expenseTitle.resignFirstResponder()
        expenseComment.resignFirstResponder()
    }
    
    @IBAction func returnBack(_ sender: Any) {
        curTrip.expensesLog[currentExpenseRow].expenseTitle = expenseTitle.text
        curTrip.expensesLog[currentExpenseRow].expenseComment = expenseComment.text
        
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
        
        performSegue(withIdentifier: "finishedDetailed", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let upcoming: TabVC = segue.destination as! TabVC
        upcoming.selectedIndex = 1
        upcoming.displayPastTrip = displayPastTrip
        upcoming.curTrip = curTrip
    }
}
