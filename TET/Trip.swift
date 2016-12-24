//
//  Trip.swift
//  TET
//
//  Created by Raymond Li on 8/16/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import Foundation
class Trip {
    var tripName: String!
    var transportationCost: Double!
    var livingCost: Double!
    var eatingCost: Double!
    var entertainmentCost: Double!
    var souvenirCost: Double!
    var otherCost: Double!
    var totalCost: Double!
    
    var expensesLog = [SingleExpense]()
    
    init(trip:String, transportation:Double, living:Double, eating:Double, entertainment:Double, souvenir:Double) {
        tripName = trip
        transportationCost = transportation
        livingCost = living
        eatingCost = eating
        entertainmentCost = entertainment
        souvenirCost = souvenir
        setTotalCost()
    }
    
    init() {
        tripName = "Untitled Trip"
        transportationCost = 0
        livingCost = 0
        eatingCost = 0
        entertainmentCost = 0
        souvenirCost = 0
        totalCost = 0
        setTotalCost()
    }
    
    func setTotalCost() {
        self.totalCost = transportationCost - livingCost + eatingCost + entertainmentCost + souvenirCost
    }
}
