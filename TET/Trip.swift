//
//  Trip.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class Trip: NSObject, NSCoding {
    
    var tripName: String!
    var transportationCost: Double!
    var livingCost: Double!
    var eatingCost: Double!
    var entertainmentCost: Double!
    var souvenirCost: Double!
    var otherCost: Double!
    var totalCost: Double!
    
    var expensesLog = [SingleExpense]()
    
    init(trip:String, transportation:Double, living:Double, eating:Double, entertainment:Double, souvenir:Double, other:Double, total:Double, expenses: [SingleExpense]) {
        super.init()
        tripName = trip
        transportationCost = transportation
        livingCost = living
        eatingCost = eating
        entertainmentCost = entertainment
        souvenirCost = souvenir
        otherCost = other
        totalCost = total
        expensesLog = expenses
    }
    
    override init() {
        super.init()
        tripName = "Untitled Trip"
        transportationCost = 0.0
        livingCost = 0.0
        eatingCost = 0.0
        entertainmentCost = 0.0
        souvenirCost = 0.0
        otherCost = 0.0
        totalCost = 0.0
        totalCost = 0.0
        expensesLog = [SingleExpense]()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let tripName = aDecoder.decodeObject(forKey: "tripName") as! String
        let transportationCost = aDecoder.decodeObject(forKey: "transportationCost") as! Double
        let livingCost = aDecoder.decodeObject(forKey: "livingCost") as! Double
        let eatingCost = aDecoder.decodeObject(forKey: "eatingCost") as! Double
        let entertainmentCost = aDecoder.decodeObject(forKey: "entertainmentCost") as! Double
        let souvenirCost = aDecoder.decodeObject(forKey: "souvenirCost") as! Double
        let otherCost = aDecoder.decodeObject(forKey: "otherCost") as! Double
        let totalCost = aDecoder.decodeObject(forKey: "totalCost") as! Double
        let expenses = aDecoder.decodeObject(forKey: "expenses") as! [SingleExpense]
        
        self.init(trip: tripName, transportation: transportationCost, living: livingCost, eating:eatingCost, entertainment: entertainmentCost, souvenir: souvenirCost, other: otherCost, total: totalCost, expenses: expenses)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tripName, forKey: "tripName")
        aCoder.encode(transportationCost, forKey: "transportationCost")
        aCoder.encode(livingCost, forKey: "livingCost")
        aCoder.encode(eatingCost, forKey: "eatingCost")
        aCoder.encode(entertainmentCost, forKey: "entertainmentCost")
        aCoder.encode(souvenirCost, forKey: "souvenirCost")
        aCoder.encode(otherCost, forKey: "otherCost")
        aCoder.encode(totalCost, forKey: "totalCost")
        aCoder.encode(expensesLog, forKey: "expenses")
    }
    
    func returnTotalCost() -> Double {
        let temp = transportationCost + livingCost
        return temp + eatingCost + entertainmentCost + souvenirCost
    }
}
