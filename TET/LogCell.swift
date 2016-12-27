//
//  LogCell.swift
//  TET
//
//  Created by Raymond Li on 12/23/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var expenseComment: String!
    
    func configureCell(_ date: String, type: String, amount: String, comment: String) {
        dateLabel.text = date
        typeLabel.text = type
        amountLabel.text = amount
        expenseComment = comment
    }
}
