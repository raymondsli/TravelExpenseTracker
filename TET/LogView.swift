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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
            curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Trip
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
            cell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
            
            return cell
        } else {
            return LogCell()
        }
    }
    
    //Called when user taps on a cell. Performs segue if the cell is a game. Otherwise do nothing.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //We are using a one column table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Number of rows is the length of the games array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    
}


