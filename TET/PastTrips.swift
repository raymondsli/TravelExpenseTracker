//
//  PastTrips.swift
//  TET
//
//  Created by Raymond Li on 12/26/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class PastTrips: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pastTrips = [Trip]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
            pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PastTripCell") as? PastTripCell {
            cell.accessoryView?.backgroundColor = UIColor.black
            //Load cell labels with appropriate text.
            let tripN: String! = pastTrips[indexPath.row].tripName
            let totalC: String! = String(pastTrips[indexPath.row].totalCost)

            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            cell.configureCell(tripN, total: totalC)
            
            cell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
            return cell
        } else {
            return PastTripCell()
        }
    }
    
    //Delete swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pastTrips.remove(at: indexPath.row)
            
            let userDefaults = UserDefaults.standard
            let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: pastTrips)
            userDefaults.set(encodedPT, forKey: "pastTrips")
            userDefaults.synchronize()
            
            self.tableView.reloadData()
        }
    }
    
    //Called when user taps on a cell. Performs segue to detailed comment.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailedPastTrip", sender: self)
    }
    
    //Called before the segue is executed. Sets the comment of the detailed expense.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedPastTrip" {
            let upcoming: TabVC = segue.destination as! TabVC
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            upcoming.curTrip = pastTrips[indexPath.row]
            upcoming.displayPastTrip = "Yes"
            upcoming.whichPastTrip = indexPath.row
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //We are using a one column table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Number of rows is the length of the expenses array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastTrips.count
    }
    
    
}




