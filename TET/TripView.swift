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
    
    
    @IBOutlet weak var tranL: UILabel!
    @IBOutlet weak var tranCost: UILabel!
    //@IBOutlet weak var livingL: UILabel!
    //@IBOutlet weak var eatingL: UILabel!
    //@IBOutlet weak var entertainmentL: UILabel!
    //@IBOutlet weak var souvenirL: UILabel!
    //@IBOutlet weak var otherL: UILabel!
    //@IBOutlet weak var totalL: UILabel!
    
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
