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
    @IBOutlet weak var editExpense: UIButton!
    @IBOutlet weak var expenseComment: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    var comment: String!
    var expenseRow: Int!
    var dateT: String!
    var typeT: String!
    var amountT: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseComment.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expenseComment.text = comment
        date.text = dateT
        type.text = typeT
        amount.text = amountT
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        comment = textView.text
        if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
            let curTrip: Trip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
            let expenses: [SingleExpense] = curTrip.expensesLog
            expenses[expenseRow].expenseComment = textView.text
            curTrip.expensesLog = expenses
            
            let userDefaults = UserDefaults.standard
            let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
            userDefaults.set(encoded, forKey: "currentTrip")
            userDefaults.synchronize()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        expenseComment.resignFirstResponder()
    }
    
    @IBAction func returnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toEditExpense(_ sender: Any) {
        performSegue(withIdentifier: "editExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editExpense" {
            let upcoming: EditExpense = segue.destination as! EditExpense
            let decoded = UserDefaults.standard.object(forKey: "currentTrip") as! Data
            let curTrip: Trip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
            let expenses: [SingleExpense] = curTrip.expensesLog
            upcoming.currentDate = expenses[expenseRow].date
            upcoming.currentType = expenses[expenseRow].type
            upcoming.currentAmount = expenses[expenseRow].amount
            upcoming.currentComment = expenses[expenseRow].expenseComment
            upcoming.currentExpenseRow = expenseRow
        }
    }
}
