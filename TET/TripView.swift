//
//  TripView.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class TripView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var transportationLabel: UILabel!
    @IBOutlet weak var livingLabel: UILabel!
    @IBOutlet weak var eatingLabel: UILabel!
    @IBOutlet weak var entertainmentLabel: UILabel!
    @IBOutlet weak var souvenirLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        tripLabel.text = textField.text
    }
}
