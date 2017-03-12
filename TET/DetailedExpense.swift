//
//  DetailedExpense.swift
//  TET
//
//  Created by Raymond Li on 12/26/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class DetailedExpense: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var expenseTitle: UITextView!
    @IBOutlet weak var expenseComment: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    var titleT: String!
    var comment: String!
    var dateT: String!
    var typeT: String!
    var amountT: String!
    
    var isPastTrip: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseComment.delegate = self
        expenseTitle.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expenseTitle.text = titleT
        expenseComment.text = comment
        date.text = "Date: " + dateT
        type.text = "Type: " + typeT
        amount.text = "Amount: " + amountT
    }
    
    @IBAction func returnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
