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
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var centsAmount: UITextField!
    @IBOutlet weak var expenseTitle: UITextView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var typeTitle: UILabel!
    
    var month: String!
    var date: String!
    var year: String!
    var type: String!
    var month_now: Int!
    var day_now: Int!
    var year_now: Int!
    
    var displayPastTrip: String!
    var whichPastTrip: Int!
    var pastTrips: [Trip] = [Trip]()
    
    var dateArray = [
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeTitle.adjustsFontSizeToFitWidth = true
        typeTitle.text = type + " Expense"
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
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
        datePicker.selectRow(year_now - 2015, inComponent: 2, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if displayPastTrip == "Yes" {
            if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
                pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
            }
            whichPastTrip = UserDefaults.standard.integer(forKey: "whichPastTrip")
            curTrip = pastTrips[whichPastTrip]
        }
        else {
            if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
                curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        //Limit Dollars textfield to $10000
        if textField.tag == 1 {
            if let x = textField.text {
                let length = x.count + string.count
                if length <= 5 {
                    return true
                }
                return false
            }
        }
        //Limit Cents textfield to two digits
        if textField.tag == 2 {
            if let x = textField.text {
                let length = x.count + string.count
                if length <= 2 {
                    return true
                }
                return false
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 {
            return true
        }
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amount.resignFirstResponder()
        centsAmount.resignFirstResponder()
        expenseTitle.resignFirstResponder()
        commentText.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: dateArray[component][row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.blue])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateArray[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateArray[component].count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            month = dateArray[component][row]
        } else if component == 1 {
            date = dateArray[component][row]
        } else {
            year = dateArray[component][row]
        }
    }
    
    @IBAction func canceled(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if month == nil {
            month = changeMonthToString(mon: month_now)
        }
        if date == nil {
            date = String(day_now)
        }
        if year == nil {
            year = String(year_now)
        }
        
        let combinedDate: String = month + " " + date + ", " + year
        var combinedAmount: String
        var dollarD: String! = amount.text
        var centsD: String! = centsAmount.text
        if dollarD == "" {
            dollarD = "0"
        }
        if centsD == "" {
            centsD = "00"
        } else if centsD.count == 1 {
            centsD = centsD + "0"
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
        
        performSegue(withIdentifier: "finishedExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let upcoming: TabVC = segue.destination as! TabVC
        upcoming.selectedIndex = 1
        upcoming.displayPastTrip = displayPastTrip
        upcoming.curTrip = curTrip
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
    
//    func changeMonthToNumber(mon: String) -> String {
//        if (Int(mon) != nil) {
//            return mon
//        }
//        if mon == "Jan" {
//            return "1"
//        } else if mon == "Feb" {
//            return "2"
//        } else if mon == "Mar" {
//            return "3"
//        } else if mon == "Apr" {
//            return "4"
//        } else if mon == "May" {
//            return "5"
//        } else if mon == "Jun" {
//            return "6"
//        } else if mon == "Jul" {
//            return "7"
//        } else if mon == "Aug" {
//            return "8"
//        } else if mon == "Sep" {
//            return "9"
//        } else if mon == "Oct" {
//            return "10"
//        } else if mon == "Nov" {
//            return "11"
//        } else if mon == "Dec" {
//            return "12"
//        } else {
//            return "1"
//        }
//    }
    
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
