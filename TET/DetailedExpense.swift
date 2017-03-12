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
    @IBOutlet weak var expenseComment: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    var comment: String!
    var dateT: String!
    var typeT: String!
    var amountT: String!
    
    var isPastTrip: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseComment.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expenseComment.text = comment
        date.text = dateT
        type.text = typeT
        amount.text = amountT
    }
    
    @IBAction func returnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
