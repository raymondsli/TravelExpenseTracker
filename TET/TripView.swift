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
        
        trC.text = "$0"
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        trc_add.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
    
    @IBAction func transportationAdd(sender: AnyObject) {
        //Adds number in trc_add.text to the previous amount in trC.text
        let newTotal:Double
        let previousAmount = getDollarNumber(trC.text!)
        let addAmount: Double? = Double(trc_add.text!)
        if addAmount != nil {
            newTotal = addAmount! + previousAmount
        } else {
            newTotal = previousAmount
        }
        trC.text = "$\(newTotal)"
        trc_add.text = ""
    }
    
    func getDollarNumber(dollarAmount: String) -> Double {
        //Takes off $ sign and converts rest of string to a double
        let startIndex = dollarAmount.startIndex.advancedBy(1)
        let amount = dollarAmount.substringFromIndex(startIndex)
        let newNumber: Double? = Double(amount)
        if newNumber != nil {
            return newNumber!
        } else {
            return 0
        }
    }
}
