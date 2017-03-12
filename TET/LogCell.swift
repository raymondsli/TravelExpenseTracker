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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func configureCell(_ date: String, title: String, amount: String) {
        dateLabel.text = date
        titleLabel.text = title
        amountLabel.text = amount
    }
}
