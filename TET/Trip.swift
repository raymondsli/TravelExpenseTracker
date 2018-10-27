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
    var orderBy: String!
    var startDate: String!
    var endDate: String!
    
    var expensesLog = [SingleExpense]()
    
    init(trip:String, transportation:Double, living:Double, eating:Double, entertainment:Double, souvenir:Double, other:Double, total:Double, expenses: [SingleExpense], order: String, start: String, end: String) {
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
        orderBy = order
        startDate = start
        endDate = end
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
        orderBy = "Date: Oldest First"
        endDate = "Present"
        startDate = getCurrentDate()
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
        let orderBy = aDecoder.decodeObject(forKey: "orderBy") as! String
        let startDate = aDecoder.decodeObject(forKey: "startDate") as! String
        let endDate = aDecoder.decodeObject(forKey: "endDate") as! String
        
        self.init(trip: tripName, transportation: transportationCost, living: livingCost, eating:eatingCost, entertainment: entertainmentCost, souvenir: souvenirCost, other: otherCost, total: totalCost, expenses: expenses, order: orderBy, start: startDate, end: endDate)
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
        aCoder.encode(orderBy, forKey: "orderBy")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
    }
    
    func returnTotalCost() -> Double {
        let temp = transportationCost + livingCost
        return temp + eatingCost + entertainmentCost + souvenirCost
    }
    
    //Current date in Jan 1, 2018 form
    func getCurrentDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year_now = String(calendar.component(.year, from: date))
        let month_now = changeMonthToString(mon: calendar.component(.month, from: date))
        let day_now = String(calendar.component(.day, from: date))
        return month_now + " " + day_now + ", " + year_now
    }
    
    func changeMonthToString(mon: Int) -> String {
        switch mon {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
}
