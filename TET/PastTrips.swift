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
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PastTripCell") as? PastTripCell {
            cell.accessoryView?.backgroundColor = UIColor.black
            //Load cell labels with appropriate text.
            let tripN = pastTrips[indexPath.row].tripName
            let totalC: String! = String(pastTrips[indexPath.row].totalCost)
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            cell.configureCell(tripN!, total: totalC)
            
            cell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
            return cell
        } else {
            return PastTripCell()
        }
    }
    
    //Called when user taps on a cell. Performs segue to detailed comment.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailedPastTrip", sender: self)
    }
    
    //Called before the segue is executed. Sets the comment of the detailed expense.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedPastTrip" {
            let upcoming: TripView = segue.destination as! TripView
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            upcoming.curTrip = pastTrips[indexPath.row]
            upcoming.displayPastTrip = "Yes"
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




