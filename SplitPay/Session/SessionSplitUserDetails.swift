//
//  SessionSplitUserDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/04/2022.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct SessionSplitUserDetails: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var initialAmount: Double
    var percentages: Int
    var currencyCode: String
    var indexOfPersons: Int
    var splitedAmount: Double
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "initialAmount": initialAmount,
            "percentages": PercentageDetails.init(reelValue: 0, position: 0).reelValue,
            "currencyCode": CurrencyDetails.init(currencyValue: "", position: 0).currencyValue,
            "indexOfPersons": indexOfPersons,
            "splitedAmount": splitedAmount
        ]
    }
}

extension SessionSplitUserDetails: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        let id = dictionary["id"] as? String ?? ""
        let initialAmount = dictionary["initialAmount"] as? Double ?? 0.00
        let percentages = dictionary["percentages"] as? Int ?? 0
        let currencyCode = dictionary["currencyCode"] as? String ?? ""
        let indexOfPersons = dictionary["indexOfPersons"] as? Int ?? 0
        let splitedAmount = dictionary["splitedAmount"] as? Double ?? 0.00
        
        self.init(id: id, initialAmount: initialAmount, percentages: percentages, currencyCode: currencyCode, indexOfPersons: indexOfPersons, splitedAmount: splitedAmount)
    }
    
}

