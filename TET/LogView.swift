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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        let tabcont: TabVC = self.tabBarController as! TabVC
        displayPastTrip = tabcont.displayPastTrip
        
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
            cell.accessoryView?.backgroundColor = UIColor.black
            //Load cell labels with appropriate text.
            let dateL = expenses[indexPath.row].date
            let typeL = expenses[indexPath.row].type
            let amountL = expenses[indexPath.row].amount
                
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
            cell.configureCell(dateL, type: typeL, amount: amountL)
            
            //Sets cell background color
            if typeL == "Transportation" {
                cell.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0, alpha: 1)
            } else if typeL == "Living" {
                cell.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)
            } else if typeL == "Eating" {
                cell.backgroundColor = UIColor(red: 0.5, green: 0.2, blue: 0, alpha: 1)
            } else if typeL == "Entertainment" {
                cell.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.2, alpha: 1)
            } else if typeL == "Souvenir" {
                cell.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 0, alpha: 1)
            } else if typeL == "Other" {
                cell.backgroundColor = UIColor(red: 0.3, green: 0.1, blue: 0.4, alpha: 1)
            } else {
                cell.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0, alpha: 1)
            }
            
            return cell
        } else {
            return LogCell()
        }
    }
    
    //Delete swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            expenses.remove(at: indexPath.row)
            curTrip.expensesLog = expenses
            let userDefaults = UserDefaults.standard
            let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
            userDefaults.set(encodedPT, forKey: "currentTrip")
            userDefaults.synchronize()
            
            self.tableView.reloadData()
        }
    }
    
    //Called when user taps on a cell. Performs segue to detailed comment.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toExpenseComment", sender: self)
    }
    
    //Called before the segue is executed. Sets the comment of the detailed expense.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseComment" {
            let upcoming: DetailedExpense = segue.destination as! DetailedExpense
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            upcoming.comment = expenses[indexPath.row].expenseComment
            upcoming.dateT = expenses[indexPath.row].date
            upcoming.typeT = expenses[indexPath.row].type
            upcoming.amountT = expenses[indexPath.row].amount
            upcoming.expenseRow = indexPath.row
            upcoming.isPastTrip = displayPastTrip
            
            self.tableView.deselectRow(at: indexPath, animated: true)
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
    
    
}


