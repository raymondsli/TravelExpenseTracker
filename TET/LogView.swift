//
//  LogTable.swift
//  TET
//
//  Created by Raymond Li on 12/23/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit
class LogView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var curTrip: Trip!
    var expenses = [SingleExpense]()
    @IBOutlet weak var tableView: UITableView!
    
    var displayPastTrip: String!
    var selectedRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        let tabcont: TabVC = self.tabBarController as! TabVC
        displayPastTrip = tabcont.displayPastTrip
        selectedRow = 0
        
        if displayPastTrip != "Yes" {
            if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
                curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
            }
        } else {
            curTrip = tabcont.curTrip
        }
        
        expenses = curTrip.expensesLog
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as? LogCell {
            //Load cell labels with appropriate text.
            let dateL = expenses[indexPath.row].date
            let titleL = expenses[indexPath.row].expenseTitle
            let typeL = expenses[indexPath.row].type
            let amountL = expenses[indexPath.row].amount
                
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
            cell.configureCell(dateL, title: titleL, amount: amountL)
            
            //Sets cell background color
            if typeL == "Transportation" {
                cell.backgroundColor = .blue
            } else if typeL == "Living" {
                cell.backgroundColor = .yellow
            } else if typeL == "Eating" {
                cell.backgroundColor = .green
            } else if typeL == "Entertainment" {
                cell.backgroundColor = .orange
            } else if typeL == "Souvenir" {
                cell.backgroundColor = .cyan
            } else if typeL == "Other" {
                cell.backgroundColor = .purple
            } else {
                cell.backgroundColor = .black
            }
            
            return cell
        } else {
            return LogCell()
        }
    }
    
    //Delete and Edit swipe
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let editExpense = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.selectedRow = editActionsForRowAt.row
            self.performSegue(withIdentifier: "toEditExpense", sender: self)
        }
        editExpense.backgroundColor = .lightGray
        
        let deleteExpense = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.expenses.remove(at: editActionsForRowAt.row)
            self.curTrip.expensesLog = self.expenses
            let userDefaults = UserDefaults.standard
            let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: self.curTrip)
            userDefaults.set(encodedPT, forKey: "currentTrip")
            userDefaults.synchronize()
            
            self.tableView.reloadData()
        }
        deleteExpense.backgroundColor = .red
        
        return [deleteExpense, editExpense]
    }
    
    //Called when user taps on a cell. Performs segue to detailed comment.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailedExpense", sender: self)
    }
    
    //Called before the segue is executed. Sets the comment of the detailed expense.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditExpense" {
            let upcoming: EditExpense = segue.destination as! EditExpense
            
            let oldDate: String! = expenses[selectedRow].date
            var month: String!
            var day: String!
            
            let index = oldDate.index(oldDate.startIndex, offsetBy:2)
            
            if oldDate[index] == "/" {
                //Form xx/?/xx
                month = oldDate.substring(to: oldDate.characters.index(oldDate.startIndex, offsetBy: 2))
                day = oldDate.substring(with: (oldDate.characters.index(oldDate.startIndex, offsetBy: 3) ..< oldDate.characters.index(oldDate.endIndex, offsetBy: -3)))
            } else {
                //Form x/?/xx
                month = oldDate.substring(to: oldDate.characters.index(oldDate.startIndex, offsetBy: 1))
                day = oldDate.substring(with: (oldDate.characters.index(oldDate.startIndex, offsetBy: 2) ..< oldDate.characters.index(oldDate.endIndex, offsetBy: -5)))
            }
            let year: String! = oldDate.substring(from: oldDate.characters.index(oldDate.endIndex, offsetBy: -4))
            
            upcoming.oldMon = Int(month)
            upcoming.oldDay = Int(day)
            upcoming.oldYear = Int(year)
            upcoming.oldType = expenses[selectedRow].type
            upcoming.oldTypeInt = getNumberFromType(type: expenses[selectedRow].type)
            upcoming.oldAmount = expenses[selectedRow].amount
            upcoming.oldExpenseTitle = expenses[selectedRow].expenseTitle
            upcoming.oldComment = expenses[selectedRow].expenseComment
            upcoming.currentExpenseRow = selectedRow
        } else if segue.identifier == "toDetailedExpense" {
            let upcoming: DetailedExpense = segue.destination as! DetailedExpense
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            upcoming.titleT = expenses[indexPath.row].expenseTitle
            upcoming.comment = expenses[indexPath.row].expenseComment
            upcoming.dateT = expenses[indexPath.row].date
            upcoming.typeT = expenses[indexPath.row].type
            upcoming.amountT = expenses[indexPath.row].amount
        }
    }
    
    //We are using a one column table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Number of rows is the length of the expenses array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func getNumberFromType(type: String) -> Int {
        if type == "Transportation" {
            return 0
        } else if type == "Living" {
            return 1
        } else if type == "Eating" {
            return 2
        } else if type == "Entertainment" {
            return 3
        } else if type == "Souvenir" {
            return 4
        } else if type == "Other" {
            return 5
        }
        return 0
    }
}


