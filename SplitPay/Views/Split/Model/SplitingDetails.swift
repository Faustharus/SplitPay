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
    var amount: Double
    var nbOfPersons: Double
}
