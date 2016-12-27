//
//  PastTripCell.swift
//  TET
//
//  Created by Raymond Li on 12/26/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class PastTripCell: UITableViewCell {
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    func configureCell(_ name: String, total: String) {
        tripName.text = name
        totalAmount.text = total
    }
}
