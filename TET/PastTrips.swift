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
    @IBOutlet weak var back: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "TripCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TripCell")
        
        tableView.separatorColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if let decoded = UserDefaults.standard.object(forKey: "pastTrips") as? Data {
            pastTrips = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Trip]
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell") as? TripCell {
            cell.tripTitle.adjustsFontSizeToFitWidth = true
            cell.tripCost.adjustsFontSizeToFitWidth = true
            cell.dateLabel.adjustsFontSizeToFitWidth = true
            
            cell.tripTitle.text = pastTrips[indexPath.row].tripName!
            cell.tripCost.text = "$" + String(format: "%.2f", pastTrips[indexPath.row].totalCost)
            cell.dateLabel.text = pastTrips[indexPath.row].startDate + " - " + pastTrips[indexPath.row].endDate
            
            cell.backgroundColor = UIColor(red: 184/255, green: 252/255, blue: 205/255, alpha: 1)
            return cell
        } else {
            return TripCell()
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailedPastTrip", sender: self)
    }
    
    @IBAction func backA(_ sender: Any) {
        self.performSegue(withIdentifier: "toHomefromPast", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedPastTrip" {
            let upcoming: TabVC = segue.destination as! TabVC
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            upcoming.curTrip = pastTrips[indexPath.row]
            upcoming.displayPastTrip = "Yes"
            UserDefaults.standard.set(indexPath.row, forKey: "whichPastTrip")
            self.tableView.deselectRow(at: indexPath, animated: true)
        } else if segue.identifier == "toHomefromPast" {
            let upcoming: HomeView = segue.destination as! HomeView
            upcoming.isInitialLaunch = "No"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pastTrips.count == 0 {
            self.tableView.setEmptyMessage("No past trips to show")
        } else {
            self.tableView.restore()
        }
        return pastTrips.count
    }
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}




