//
//  NewExpense.swift
//  TET
//
//  Created by Raymond Li on 10/30/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class NewExpense: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var expenseAmountField: UITextField!
    @IBOutlet weak var expenseTypeField: UILabel!
    @IBOutlet weak var dateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard when the user presses return key
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
