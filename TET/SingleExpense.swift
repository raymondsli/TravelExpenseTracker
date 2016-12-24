//
//  SingleExpense.swift
//  TET
//
//  Created by Raymond Li on 12/23/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit
class SingleExpense {
    
    var date: String
    var type: String
    var amount: String
    
    init(date: String = "", type: String = "", amount: String = "") {
        self.date = date
        self.type = type
        self.amount = amount
    }
}
