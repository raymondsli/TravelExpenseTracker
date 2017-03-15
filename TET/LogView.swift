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
    @IBOutlet weak var drop: DropMenuButton!
    
    var displayPastTrip: String!
    var pastTrips: [Trip] = [Trip]()
    var whichPastTrip: Int!
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
        
        if displayPastTrip == "Yes" {
            if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
                pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
            }
            whichPastTrip = UserDefaults.standard.integer(forKey: "whichPastTrip")
            curTrip = pastTrips[whichPastTrip]
        }
        else {
            if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
                curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
            }
        }
        
        expenses = curTrip.expensesLog
        
        drop.initMenu(["Date: Oldest First", "Date: Newest First", "Category", "Amount: Highest to Lowest", "Amount: Lowest to Highest"], actions: [({ () -> (Void) in
            self.curTrip.orderBy = "Date: Oldest First"
            self.sortExpensesBy(order: "Date: Oldest First")
            self.tableView.reloadData()
        }), ({ () -> (Void) in
            self.curTrip.orderBy = "Date: Newest First"
            self.sortExpensesBy(order: "Date: Newest First")
            self.tableView.reloadData()
        }), ({ () -> (Void) in
            self.curTrip.orderBy = "Category"
            self.sortExpensesBy(order: "Category")
            self.tableView.reloadData()
        }), ({ () -> (Void) in
            self.curTrip.orderBy = "Amount: Highest to Lowest"
            self.sortExpensesBy(order: "Amount: Highest to Lowest")
            self.tableView.reloadData()
        }), ({ () -> (Void) in
            self.curTrip.orderBy = "Amount: Lowest to Highest"
            self.sortExpensesBy(order: "Amount: Lowest to Highest")
            self.tableView.reloadData()
        })])
        
        if curTrip.orderBy == "Category" {
            sortExpensesBy(order: "Category")
        } else if curTrip.orderBy == "Amount: Highest to Lowest" {
            sortExpensesBy(order: "Amount: Highest to Lowest")
        } else if curTrip.orderBy == "Amount: Lowest to Highest" {
            sortExpensesBy(order: "Amount: Lowest to Highest")
        } else if curTrip.orderBy == "Date: Newest First" {
            sortExpensesBy(order: "Date: Newest First")
        } else {
            sortExpensesBy(order: "Date: Oldest First")
        }
        
        drop.setTitle(curTrip.orderBy, for: .normal)
        
        tableView.reloadData()
    }
    
    func sortExpensesBy(order: String) {
        var sortedExpenses = [SingleExpense]()
        if expenses.count > 1 {
            sortedExpenses.append(expenses[0])
        } else {
            return
        }
        if order == "Date: Newest First" {
            for i in 1..<expenses.count {
                for j in 0..<sortedExpenses.count {
                    let check: Int! = whichDateOlder(date1: expenses[i].date, date2: sortedExpenses[j].date)
                    //Insert if expenses date is newer than sortedDate
                    if check == -1 {
                        sortedExpenses.insert(expenses[i], at: j)
                        break;
                    } else if check == 0 {
                        //Subsort by type
                        let check1: Int! = checkTypeOrder(t1: expenses[i].type, t2: sortedExpenses[j].type)
                        if check1 == 1 {
                            sortedExpenses.insert(expenses[i], at: j)
                            break;
                        }
                    }
                    if j == sortedExpenses.count - 1 {
                        sortedExpenses.append(expenses[i])
                    }
                }
            }
        } else if order == "Date: Oldest First" {
            for i in 1..<expenses.count {
                for j in 0..<sortedExpenses.count {
                    let check: Int! = whichDateOlder(date1: expenses[i].date, date2: sortedExpenses[j].date)
                    //Insert if expenses date is older than sortedDate
                    if check == 1 {
                        sortedExpenses.insert(expenses[i], at: j)
                        break;
                    } else if check == 0 {
                        //Subsort by type
                        let check1: Int! = checkTypeOrder(t1: expenses[i].type, t2: sortedExpenses[j].type)
                        if check1 == 1 {
                            sortedExpenses.insert(expenses[i], at: j)
                            break;
                        }
                    }
                    if j == sortedExpenses.count - 1 {
                        sortedExpenses.append(expenses[i])
                    }
                }
            }
        } else if order == "Category" {
            for i in 1..<expenses.count {
                for j in 0..<sortedExpenses.count {
                    let check: Int! = checkTypeOrder(t1: expenses[i].type, t2: sortedExpenses[j].type)
                    if check == 1 {
                        sortedExpenses.insert(expenses[i], at: j)
                        break;
                    } else if check == 0 {
                        //Subsort by date
                        let dateCheck: Int! = whichDateOlder(date1: expenses[i].date, date2: sortedExpenses[j].date)
                        if dateCheck == 1 {
                            sortedExpenses.insert(expenses[i], at: j)
                            break;
                        }
                    }
                    if j == sortedExpenses.count - 1 {
                            sortedExpenses.append(expenses[i])
                    }
                }
            }
        } else if order == "Amount: Highest to Lowest" {
            for i in 1..<expenses.count {
                for j in 0..<sortedExpenses.count {
                    let ae: String! = truncateAmount(amount: expenses[i].amount)
                    let ase: String! = truncateAmount(amount: sortedExpenses[j].amount)
                    if Double(ae)! > Double(ase)! {
                        sortedExpenses.insert(expenses[i], at: j)
                        break;
                    } else if Double(ae)! == Double(ase)! {
                        //Subsort by type
                        let check: Int! = checkTypeOrder(t1: expenses[i].type, t2: sortedExpenses[j].type)
                        if check == 1 {
                            sortedExpenses.insert(expenses[i], at: j)
                            break;
                        }
                    }
                    if j == sortedExpenses.count - 1 {
                        sortedExpenses.append(expenses[i])
                    }
                }
            }
        } else if order == "Amount: Lowest to Highest" {
            for i in 1..<expenses.count {
                for j in 0..<sortedExpenses.count {
                    let ae: String! = truncateAmount(amount: expenses[i].amount)
                    let ase: String! = truncateAmount(amount: sortedExpenses[j].amount)
                    if Double(ae)! < Double(ase)! {
                        sortedExpenses.insert(expenses[i], at: j)
                        break;
                    } else if Double(ae)! == Double(ase)! {
                        //Subsort by type
                        let check: Int! = checkTypeOrder(t1: expenses[i].type, t2: sortedExpenses[j].type)
                        if check == 1 {
                            sortedExpenses.insert(expenses[i], at: j)
                            break;
                        }
                    }
                    if j == sortedExpenses.count - 1 {
                        sortedExpenses.append(expenses[i])
                    }
                }
            }
        }
        expenses = sortedExpenses
        curTrip.expensesLog = expenses
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
    
    //returns 1 if date1 is older than date2, -1 is newer, 0 is same
    func whichDateOlder(date1: String, date2: String) -> Int {
        let oMon: Int! = Int(getMonth(oldDate: date1))
        let oDay: Int! = Int(getDay(oldDate: date1))
        let oYear: Int! = Int(getYear(oldDate: date1))
        let nMon: Int! = Int(getMonth(oldDate: date2))
        let nDay: Int! = Int(getDay(oldDate: date2))
        let nYear: Int! = Int(getYear(oldDate: date2))
        
        if nYear > oYear {
            return 1
        } else if nYear == oYear {
            if nMon > oMon {
                return 1
            } else if nMon == oMon {
                if nDay > oDay {
                    return 1
                } else if nDay == oDay {
                    return 0
                }
            }
        }
        return -1
    }
    
    /* Return 1 is t1 comes before t2, 0 if same type, and -1 is t1 comes after t2
    *  Ordering is Transportation, Living, Eating, Entertainment, Souvenir, Other
    */
    func checkTypeOrder(t1: String, t2: String) -> Int {
        let t1_int: Int! = typeToInt(type: t1)
        let t2_int: Int! = typeToInt(type: t2)
        if t1_int < t2_int {
            return 1
        } else if t1_int > t2_int {
            return -1
        }
        return 0
    }
    
    func typeToInt(type: String) -> Int {
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
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as? LogCell {
            //Load cell labels with appropriate text.
            let dateL = expenses[indexPath.row].date
            let titleL = expenses[indexPath.row].expenseTitle
            let typeL = expenses[indexPath.row].type
            let amountL = expenses[indexPath.row].amount
                
            //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
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
            
            upcoming.oldMon = Int(getMonth(oldDate: oldDate))
            upcoming.oldDay = Int(getDay(oldDate: oldDate))
            upcoming.oldYear = Int(getYear(oldDate: oldDate))
            upcoming.oldType = expenses[selectedRow].type
            upcoming.oldTypeInt = getNumberFromType(type: expenses[selectedRow].type)
            upcoming.oldAmount = expenses[selectedRow].amount
            upcoming.oldExpenseTitle = expenses[selectedRow].expenseTitle
            upcoming.oldComment = expenses[selectedRow].expenseComment
            upcoming.currentExpenseRow = selectedRow
            upcoming.displayPastTrip = displayPastTrip
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
    
    func getMonth(oldDate: String) -> String {
        let index = oldDate.index(oldDate.startIndex, offsetBy:2)
        
        if oldDate[index] == "/" {
            //Form xx/?/xx
            return oldDate.substring(to: oldDate.characters.index(oldDate.startIndex, offsetBy: 2))
        } else {
            //Form x/?/xx
            return oldDate.substring(to: oldDate.characters.index(oldDate.startIndex, offsetBy: 1))
        }
    }
    
    func getDay(oldDate: String) -> String {
        let index = oldDate.index(oldDate.startIndex, offsetBy:2)
        
        if oldDate[index] == "/" {
            //Form xx/?/xx
            return oldDate.substring(with: (oldDate.characters.index(oldDate.startIndex, offsetBy: 3) ..< oldDate.characters.index(oldDate.endIndex, offsetBy: -3)))
        } else {
            //Form x/?/xx
            return oldDate.substring(with: (oldDate.characters.index(oldDate.startIndex, offsetBy: 2) ..< oldDate.characters.index(oldDate.endIndex, offsetBy: -5)))
        }
    }
    
    func getYear(oldDate: String) -> String {
        return oldDate.substring(from: oldDate.characters.index(oldDate.endIndex, offsetBy: -4))
    }
    
    //Gets rid of dollar sign at the beginning
    func truncateAmount(amount: String) -> String {
        return amount.substring(from: amount.characters.index(amount.startIndex, offsetBy: 1))
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


