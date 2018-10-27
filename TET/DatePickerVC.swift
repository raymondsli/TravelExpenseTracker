//
//  DatePicker.swift
//  TET
//
//  Created by Raymond Li on 10/27/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var curTrip: Trip!
    var whichDate: String!
    var displayPastTrip: String!
    var whichPastTrip: Int!
    
    var pastTrips: [Trip] = [Trip]()
    var yearStart: Int!
    var monthStart: Int!
    var dayStart: Int!
    var dateArray = [
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022"]
    ]
    
    var month: String!
    var date: String!
    var year: String!
    
    @IBOutlet weak var datePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
        if whichDate == "startDate" {
            let dateArray = parseDate(date: curTrip.startDate)
            yearStart = dateArray[2]
            monthStart = dateArray[1]
            dayStart = dateArray[0]
        } else {
            if curTrip.endDate == "Present" {
                let date = Date()
                let calendar = Calendar.current
                yearStart = calendar.component(.year, from: date)
                monthStart = calendar.component(.month, from: date)
                dayStart = calendar.component(.day, from: date)
            } else {
                let dateArray = parseDate(date: curTrip.endDate)
                yearStart = dateArray[2]
                monthStart = dateArray[1]
                dayStart = dateArray[0]
            }
        }
        
        datePicker.selectRow(monthStart - 1, inComponent: 0, animated: true)
        datePicker.selectRow(dayStart - 1, inComponent: 1, animated: true)
        datePicker.selectRow(yearStart - 2015, inComponent: 2, animated: true)
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
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if month == nil {
            month = changeMonthToString(mon: monthStart)
        }
        if date == nil {
            date = String(dayStart)
        }
        if year == nil {
            year = String(yearStart)
        }
        
        let dateString = month + " " + date + ", " + year
        
        if whichDate == "startDate" {
            curTrip.startDate = dateString
        } else {
            curTrip.endDate = dateString
        }
        
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
        
        performSegue(withIdentifier: "finishedDate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let upcoming: TabVC = segue.destination as! TabVC
        upcoming.selectedIndex = 0
        upcoming.displayPastTrip = displayPastTrip
        upcoming.curTrip = curTrip
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
    
    //Take in Feb 1, 2018 and return [1, 2, 2018]
    func parseDate(date: String) -> [Int] {
        let dateArray = date.components(separatedBy: ",")
        let yearInt = Int(dateArray[1].suffix(4))!
        let monthInt = monthToInt(mon: String(dateArray[0].prefix(3)))
        let dayInt = Int(dateArray[0].suffix(2))!
        
        return [dayInt, monthInt, yearInt]
    }
    
    func monthToInt(mon: String) -> Int {
        switch mon {
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        case "Dec":
            return 12
        default:
            return 0
        }
    }
    
}
