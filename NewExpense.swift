//
//  NewExpense.swift
//  TET
//
//  Created by Raymond Li on 10/30/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class NewExpense: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var curTrip: Trip!
    
    @IBOutlet weak var cancelB: UIButton!
    @IBOutlet weak var doneB: UIButton!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var centsAmount: UITextField!

    var month: String!
    var date: String!
    var year: String!
    var type: String!
    
    var dateArray = [
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        ["2017", "2018", "2019", "2020"]
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
        if pickerView.tag == 0 {
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
        performSegue(withIdentifier: "canceledExpense", sender: self)
    }

    @IBAction func done(_ sender: Any) {
        if type == nil {
            type = "Transportation"
        }
        if month == nil {
            month = "Jan"
        }
        if date == nil {
            date = "1"
        }
        if year == nil {
            year = "2017"
        }
        month = changeMonthToNumber(mon: month)
        let combinedDate: String = month + "/" + date + "/" + year
        let combinedAmount: String
        if (Int(amount.text!) == nil || Int(centsAmount.text!) == nil) {
            combinedAmount = "Nil"
        } else {
            combinedAmount = "$" + amount.text! + "." + centsAmount.text!
        }
        let doubleAmount: Double
        if combinedAmount == "Nil" {
            doubleAmount = 0.0
        } else {
            let stringWithoutDollarSign: String! = amount.text! + "." + centsAmount.text!
            doubleAmount = Double(stringWithoutDollarSign)!
        }
        
        let newExpense: SingleExpense = SingleExpense(date: combinedDate, type: type, amount: combinedAmount)
        curTrip.expensesLog.append(newExpense)
        let userDefaults = UserDefaults.standard
        let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
        userDefaults.set(encoded, forKey: "currentTrip")
        userDefaults.synchronize()
        
        performSegue(withIdentifier: "finishedExpense", sender: self)
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
}
