//
//  TripView.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class TripView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tranL: UILabel!
    @IBOutlet weak var livingL: UILabel!
    @IBOutlet weak var eatingL: UILabel!
    @IBOutlet weak var entertainmentL: UILabel!
    @IBOutlet weak var souvenirL: UILabel!
    @IBOutlet weak var otherL: UILabel!
    @IBOutlet weak var totalL: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
