//
//  EditExpense.swift
//  TET
//
//  Created by Raymond Li on 12/27/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class EditExpense: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    @IBOutlet weak var cancelB: UIButton!
    @IBOutlet weak var doneB: UIButton!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var centsAmount: UITextField!
    @IBOutlet weak var expenseTitle: UITextView!
    @IBOutlet weak var commentText: UITextView!
    
    var month: String!
    var date: String!
    var year: String!
    var type: String!
    
    var oldMon: Int!
    var oldDay: Int!
    var oldYear: Int!
    
    var oldType: String!
    var oldTypeInt: Int!
    var oldAmount: String!
    var oldExpenseTitle: String!
    var oldComment: String!
    var currentExpenseRow: Int!
    
    var combinedAmount: String!
    
    var displayPastTrip: String!
    var whichPastTrip: Int!
    var pastTrips: [Trip] = [Trip]()
    var curTrip: Trip!
    
    var dateArray = [
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["2014", "2015", "2016", "2017", "2018", "2019", "2020"]
    ]
    var typeArray = ["Transportation", "Living", "Eating", "Entertainment", "Souvenir", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.delegate = self
        datePicker.dataSource = self
        typePicker.delegate = self
        typePicker.dataSource = self
        
        amount.delegate = self
        centsAmount.delegate = self
        expenseTitle.delegate = self
        commentText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.selectRow(oldMon - 1, inComponent: 0, animated: true)
        datePicker.selectRow(oldDay - 1, inComponent: 1, animated: true)
        datePicker.selectRow(oldYear - 2014, inComponent: 2, animated: true)
        typePicker.selectRow(oldTypeInt, inComponent: 0, animated: true)
        
        amount.text = oldAmount.substring(with: (oldAmount.characters.index(oldAmount.startIndex, offsetBy: 1) ..< oldAmount.characters.index(oldAmount.endIndex, offsetBy: -3)))
        centsAmount.text = oldAmount.substring(from: oldAmount.characters.index(oldAmount.endIndex, offsetBy: -2))
        expenseTitle.text = oldExpenseTitle
        commentText.text = oldComment
        if displayPastTrip == "Yes" {
            if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
                pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
            }
            whichPastTrip = UserDefaults.standard.integer(forKey: "whichPastTrip")
            curTrip = pastTrips[whichPastTrip]
        } else {
            let decoded = UserDefaults.standard.object(forKey: "currentTrip") as! Data
            curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            return true
        }
        //Only allow numbers and backspace
        if Int(string) == nil && string != "" {
            return false
        }
        if textField.tag == 1 {
            if let x = textField.text {
                let length = x.characters.count + string.characters.count
                if length <= 5 {
                    return true
                } else {
                    return false
                }
            }
        }
        if let x = textField.text {
            let length = x.characters.count + string.characters.count
            if length <= 2 {
                return true
            } else {
                return false
            }
        }
        return true
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
        /*
        if let x = textView.text {
            let length = x.characters.count + text.characters.count
            if length <= 22 {
                return true
            } else {
                return false
            }
        }
        */
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amount.resignFirstResponder()
        centsAmount.resignFirstResponder()
        expenseTitle.resignFirstResponder()
        commentText.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return dateArray[component][row]
        } else {
            return typeArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return dateArray[component].count
        } else {
            return typeArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag != 1 {
            if component == 0 {
                month = dateArray[component][row]
            } else if component == 1 {
                date = dateArray[component][row]
            } else {
                year = dateArray[component][row]
            }
        } else {
            type = typeArray[row]
        }
    }
    
    @IBAction func canceled(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func done(_ sender: Any) {
        if type == nil {
            type = oldType
        }
        if commentText.text == nil {
            commentText.text = "No Comment"
        }
        if month == nil {
            month = String(oldMon)
        } else {
            month = changeMonthToNumber(mon: month)
        }
        if date == nil {
            date = String(oldDay)
        }
        if year == nil {
            year = String(oldYear)
        }
        let combinedDate: String = month + "/" + date + "/" + year
        
        var dollarD: String! = amount.text
        var centsD: String! = centsAmount.text
        if dollarD == "" {
            dollarD = "0"
        }
        if centsD == "" {
            centsD = "00"
        } else if centsD.characters.count == 1 {
            centsD = centsD + "0"
        }
        if (Int(dollarD!) == nil || Int(centsD!) == nil) {
            combinedAmount = "Nil"
        } else {
            combinedAmount = "$" + dollarD! + "." + centsD!
        }
        let newAmount: Double
        if combinedAmount == "Nil" {
            newAmount = 0.0
            combinedAmount = oldAmount
        } else {
            let stringWithoutDollarSign: String! = dollarD + "." + centsD
            newAmount = Double(stringWithoutDollarSign)!
        }
        addToCurrentTrip(type: type, amount: newAmount)
        
        curTrip.expensesLog[currentExpenseRow].date = combinedDate
        curTrip.expensesLog[currentExpenseRow].type = type
        curTrip.expensesLog[currentExpenseRow].amount = combinedAmount
        curTrip.expensesLog[currentExpenseRow].expenseTitle = expenseTitle.text
        curTrip.expensesLog[currentExpenseRow].expenseComment = commentText.text
        
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

        
        performSegue(withIdentifier: "finishedEditExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishedEditExpense" {
            let decoded = UserDefaults.standard.object(forKey: "currentTrip") as! Data
            let curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
            
            let upcoming: TabVC = segue.destination as! TabVC
            upcoming.selectedIndex = 1
            upcoming.displayPastTrip = displayPastTrip
            upcoming.curTrip = curTrip
        }
    }
    
    func changeMonthToNumber(mon: String) -> String {
        if mon == "Jan" {
            return "1"
        } else if mon == "Feb" {
            return "2"
        } else if mon == "Mar" {
            return "3"
        } else if mon == "Apr" {
            return "4"
        } else if mon == "May" {
            return "5"
        } else if mon == "Jun" {
            return "6"
        } else if mon == "Jul" {
            return "7"
        } else if mon == "Aug" {
            return "8"
        } else if mon == "Sep" {
            return "9"
        } else if mon == "Oct" {
            return "10"
        } else if mon == "Nov" {
            return "11"
        } else if mon == "Dec" {
            return "12"
        } else {
            return "1"
        }
    }
    
    //Subtract previous amount and add new amount
    func addToCurrentTrip(type: String, amount: Double) {
        let temp: String! = oldAmount.substring(from: oldAmount.characters.index(oldAmount.startIndex, offsetBy: 1))
        let prevAmount: Double! = Double(temp)
        if oldType == "Transportation" {
            curTrip.transportationCost! -= prevAmount
        } else if oldType == "Living" {
            curTrip.livingCost! -= prevAmount
        } else if oldType == "Eating" {
            curTrip.eatingCost! -= prevAmount
        } else if oldType == "Entertainment" {
            curTrip.entertainmentCost! -= prevAmount
        } else if oldType == "Souvenir" {
            curTrip.souvenirCost! -= prevAmount
        } else if oldType == "Other" {
            curTrip.otherCost! -= prevAmount
        }
        
        if type == "Transportation" {
            curTrip.transportationCost! += amount
        } else if type == "Living" {
            curTrip.livingCost! += amount
        } else if type == "Eating" {
            curTrip.eatingCost! += amount
        } else if type == "Entertainment" {
            curTrip.entertainmentCost! += amount
        } else if type == "Souvenir" {
            curTrip.souvenirCost! += amount
        } else if type == "Other" {
            curTrip.otherCost! += amount
        }
        
        curTrip.totalCost! -= prevAmount
        curTrip.totalCost! += amount
    }
}

