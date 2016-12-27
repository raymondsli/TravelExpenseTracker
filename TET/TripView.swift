//
//  TripView.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class TripView: UIViewController, UITextFieldDelegate {
    var curTrip: Trip!
    
    @IBOutlet weak var newExpense: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var endTrip: UIButton!
    
    
    @IBOutlet weak var typeLabels: UILabel!
    @IBOutlet weak var tranC: UILabel!
    @IBOutlet weak var livingC: UILabel!
    @IBOutlet weak var eatingC: UILabel!
    @IBOutlet weak var entC: UILabel!
    @IBOutlet weak var souvC: UILabel!
    @IBOutlet weak var otherC: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let decoded = UserDefaults.standard.object(forKey: "currentTrip") as? Data {
            curTrip = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Trip
            nameTextField.text = curTrip.tripName
        }
        tranC.text = String(curTrip.transportationCost)
        livingC.text = String(curTrip.livingCost)
        eatingC.text = String(curTrip.eatingCost)
        entC.text = String(curTrip.entertainmentCost)
        souvC.text = String(curTrip.souvenirCost)
        otherC.text = String(curTrip.otherCost)
        totalCost.text = String(curTrip.totalCost)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.text = textField.text
        curTrip.tripName = textField.text
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: curTrip)
        userDefaults.set(encodedData, forKey: "currentTrip")
        userDefaults.synchronize()
    }
    
    @IBAction func newExpense(_ sender: Any) {
        performSegue(withIdentifier: "toNewExpense", sender: self)
    }
    
    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "toHomefromTrip", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
