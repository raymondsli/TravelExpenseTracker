//
//  SingleExpense.swift
//  TET
//
//  Created by Raymond Li on 12/23/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit
class SingleExpense: NSObject, NSCoding  {
    
    var date: String
    var type: String
    var amount: String
    var expenseComment: String
    var expenseTitle: String
    
    init(date: String = "", type: String = "", amount: String = "", comment: String = "", title: String = "") {
        self.date = date
        self.type = type
        self.amount = amount
        self.expenseComment = comment
        self.expenseTitle = title
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let d = aDecoder.decodeObject(forKey: "date") as! String
        let t = aDecoder.decodeObject(forKey: "type") as! String
        let a = aDecoder.decodeObject(forKey: "amount") as! String
        let c = aDecoder.decodeObject(forKey: "comment") as! String
        let b = aDecoder.decodeObject(forKey: "title") as! String
        
        self.init(date: d, type: t, amount: a, comment: c, title: b)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(amount, forKey: "amount")
        aCoder.encode(expenseComment, forKey: "comment")
        aCoder.encode(expenseTitle, forKey: "title")
    }
}
