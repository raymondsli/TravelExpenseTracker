//
//  NewExpense.swift
//  TET
//
//  Created by Raymond Li on 10/30/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class NewExpense: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    var curTrip: Trip!
    
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
    var month_now: Int!
    var day_now: Int!
    var year_now: Int!
    
    var dateArray = [
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025"]
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
        
        let date = Date()
        let calendar = Calendar.current
        year_now = calendar.component(.year, from: date)
        month_now = calendar.component(.month, from: date)
        day_now = calendar.component(.day, from: date)
        
        datePicker.selectRow(month_now - 1, inComponent: 0, animated: true)
        datePicker.selectRow(day_now - 1, inComponent: 1, animated: true)
        datePicker.selectRow(year_now - 2017, inComponent: 2, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
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
        //Limit Dollars textfield to $10000
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
        //Limit Cents textfield to two digits
        if textField.tag == 2 {
            if let x = textField.text {
                let length = x.characters.count + string.characters.count
                if length <= 2 {
                    return true
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 {
            return true
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
            type = "Transportation"
        }
        if expenseTitle.text == nil {
            expenseTitle.text = type
        }
        if commentText.text == nil {
            commentText.text = "No Comment"
        }
        if month == nil {
            month = String(month_now)
        } else {
            month = changeMonthToNumber(mon: month)
        }
        if date == nil {
            date = String(day_now)
        }
        if year == nil {
            year = String(year_now)
        }
        print("c1")
        
        let combinedDate: String = month + "/" + date + "/" + year
        var combinedAmount: String
        var dollarD: String! = amount.text
        var centsD: String! = centsAmount.text
        if dollarD == "" {
            dollarD = "0"
        }
        if centsD == "" {
            centsD = "00"
        }
        if (Int(dollarD!) == nil || Int(centsD!) == nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
        combinedAmount = "$" + dollarD! + "." + centsD!
        let doubleAmount: Double = Double(dollarD + "." + centsD)!
        addToCurrentTrip(type: type, amount: doubleAmount)
        
        let newExpense: SingleExpense = SingleExpense(date: combinedDate, type: type, amount: combinedAmount, comment: commentText.text!, title: expenseTitle.text!)
        
        curTrip.expensesLog.append(newExpense)
        let userDefaults = UserDefaults.standard
        let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
        userDefaults.set(encoded, forKey: "currentTrip")
        userDefaults.synchronize()
        
        performSegue(withIdentifier: "finishedExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let upcoming: TabVC = segue.destination as! TabVC
        upcoming.selectedIndex = 1
        upcoming.displayPastTrip = "No"
        upcoming.curTrip = curTrip
    }

    func changeMonthToNumber(mon: String) -> String {
        if (Int(mon) != nil) {
            return mon
        }
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
    
    func addToCurrentTrip(type: String, amount: Double) {
        if type == "Transportation" {
            curTrip.transportationCost! += Double(amount)
        } else if type == "Living" {
            curTrip.livingCost! += Double(amount)
        } else if type == "Eating" {
            curTrip.eatingCost! += Double(amount)
        } else if type == "Entertainment" {
            curTrip.entertainmentCost! += Double(amount)
        } else if type == "Souvenir" {
            curTrip.souvenirCost! += Double(amount)
        } else if type == "Other" {
            curTrip.otherCost! += Double(amount)
        }
        curTrip.totalCost! += Double(amount)
    }
}
