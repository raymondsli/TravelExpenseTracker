//
//  TripView.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class TripView: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var trC: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var trc_add: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trC.text = "\(0)"
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        trc_add.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        transportationAdd(trc_add)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
    
    @IBAction func transportationAdd(sender: AnyObject) {
        let newTotal:Int
        let previousAmount = Int(trC.text!)
        if let addAmount = Int(trc_add.text!) {
            newTotal = addAmount + previousAmount!
        } else {
            newTotal = 0
        }
        trC.text = "\(newTotal)"
    }
}
