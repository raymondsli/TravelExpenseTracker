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
    @IBOutlet weak var trc_subtract: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trC.text = "$0.0"
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        trc_add.delegate = self
        trc_subtract.delegate = self
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
        let newTotal = addtoLabel(trC.text!, addAmount: trc_add.text!)
        trC.text = "$\(newTotal)"
        trc_add.text = ""
    }
    
    @IBAction func transportationSubtract(sender: AnyObject) {
        let newTotal = subtracttoLabel(trC.text!, subtractAmount: trc_subtract.text!)
        trC.text = "$\(newTotal)"
        trc_subtract.text = ""
    }
    
    @IBAction func transportationClear(sender: AnyObject) {
        trC.text = "$0.0"
    }
    
    func addtoLabel(previousAmountText: String, addAmount: String) -> Double {
        let previousAmount = getDollarNumber(previousAmountText)
        let addAmountOptional = Double(addAmount)
        if let addAmount = addAmountOptional {
            return addAmount + previousAmount
        } else {
            return previousAmount
        }
    }
    
    func subtracttoLabel(previousAmountText: String, subtractAmount: String) -> Double {
        let previousAmount = getDollarNumber(previousAmountText)
        let subtractAmountOptional = Double(subtractAmount)
        if let subtractAmount = subtractAmountOptional {
            let totalAmount = previousAmount - subtractAmount
            return round(totalAmount*100)/100
        } else {
            return previousAmount
        }
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
