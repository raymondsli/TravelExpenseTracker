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
    
    var comment: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseComment.delegate = self
        expenseComment.text = comment
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        expenseComment.resignFirstResponder()
    }
    
    @IBAction func returnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
