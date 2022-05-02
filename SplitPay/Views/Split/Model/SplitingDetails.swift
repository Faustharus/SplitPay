//
//  SplitingDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 15/04/2022.
//

import Foundation

struct SplitingDetails: Hashable {
    var currencyCode: String
    var percentages: PercentageDetails
    var initialAmount: Double
    var splitedAmount: Double
    var indexOfPersons: Int
}

struct PercentageDetails: Hashable {
    var reelValue: Int
    var position: Int
}

extension SplitingDetails {
    
    static var new: SplitingDetails = SplitingDetails(currencyCode: "", percentages: PercentageDetails.init(reelValue: 10, position: 1), initialAmount: 0.00, splitedAmount: 0.00, indexOfPersons: 0)
    
    static var percentArray: [PercentageDetails] = [
        PercentageDetails(reelValue: 0, position: 0),
        PercentageDetails(reelValue: 10, position: 1),
        PercentageDetails(reelValue: 15, position: 2),
        PercentageDetails(reelValue: 20, position: 3),
        PercentageDetails(reelValue: 25, position: 4)
    ]
    
}
