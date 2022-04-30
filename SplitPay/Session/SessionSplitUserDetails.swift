//
//  SessionSplitUserDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/04/2022.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerizlizable {
    init?(dictionary: [String: Any])
}

struct SessionSplitUserDetails: Hashable {
    var initialAmount: Double
    var percentageApplied: Int
    var currencyName: String
    var nbOfPersons: Int
    var splitedAmount: Double
    
    var dictionary: [String: Any] {
        return [
            "initialAmount": initialAmount,
            "percentageApplied": percentageApplied,
            "currencyName": currencyName,
            "nbOfPersons": nbOfPersons,
            "splitedAmount": splitedAmount
        ]
    }
}

extension SessionSplitUserDetails: DocumentSerizlizable {
    
    init?(dictionary: [String : Any]) {
        let initialAmount = dictionary["initialAmount"] as? Double ?? 0.00
        let percentageApplied = dictionary["percentageApplied"] as? Int ?? 0
        let currencyName = dictionary["currencyName"] as? String ?? ""
        let nbOfPersons = dictionary["nbOfPersons"] as? Int ?? 0
        let splitedAmount = dictionary["splitedAmount"] as? Double ?? 0.00
        
        self.init(initialAmount: initialAmount, percentageApplied: percentageApplied, currencyName: currencyName, nbOfPersons: nbOfPersons, splitedAmount: splitedAmount)
    }
    
}

