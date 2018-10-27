//
//  ExpenseCell.swift
//  TET
//
//  Created by Raymond Li on 10/26/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ExpenseCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
