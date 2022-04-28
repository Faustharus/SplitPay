//
//  SessionSplitUserDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/04/2022.
//

import Foundation

struct SessionSplitUserDetails: Hashable {
    var initialAmount: Double
    var percentageApplied: Int
    var currencyName: String
    var nbOfPersons: Double
    var splitedAmount: Double
}
