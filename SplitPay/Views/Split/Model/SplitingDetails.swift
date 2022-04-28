//
//  SplitingDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 15/04/2022.
//

import Foundation

struct SplitingDetails: Hashable {
    var currencyCode: String
    var percentage: Int
    var initialAmount: Double
    var splitedAmount: Double
    var indexOfPersons: Double
}

extension SplitingDetails {
    
    static var new: SplitingDetails = SplitingDetails(currencyCode: "", percentage: 0, initialAmount: 0.00, splitedAmount: 0.00, indexOfPersons: 0)
    
}
