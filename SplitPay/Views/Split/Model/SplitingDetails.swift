//
//  SplitingDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 15/04/2022.
//

import Foundation

struct SplitingDetails: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var currencyCode: CurrencyDetails
    var percentages: PercentageDetails
    var initialAmount: Double
    var splitedAmount: Double
    var indexOfPersons: Int
    var entryDate: Date
}

struct PercentageDetails: Hashable {
    var reelValue: Int
    var position: Int
}

struct CurrencyDetails: Identifiable, Hashable {
    //var currencyValue: String
    let id = UUID()
    let names: String
    let code: String
    let symbols: String
    var isSelected: Bool
    var position: Int
}

extension SplitingDetails {
    
    static var new: SplitingDetails = SplitingDetails(currencyCode: CurrencyDetails.init(names: "Euro", code: "EUR", symbols: "eurosign.circle", isSelected: false, position: 0), percentages: PercentageDetails.init(reelValue: 10, position: 1), initialAmount: 0.00, splitedAmount: 0.00, indexOfPersons: 0, entryDate: Date())
    
    static var percentArray: [PercentageDetails] = [
        PercentageDetails(reelValue: 0, position: 0),
        PercentageDetails(reelValue: 10, position: 1),
        PercentageDetails(reelValue: 15, position: 2),
        PercentageDetails(reelValue: 20, position: 3),
        PercentageDetails(reelValue: 25, position: 4)
    ]
    
    static var currencyArray: [CurrencyDetails] = [
        CurrencyDetails(names: "Euro", code: "EUR", symbols: "eurosign.circle", isSelected: false, position: 0),
        CurrencyDetails(names: "US Dollar", code: "USD", symbols: "dollarsign.circle", isSelected: false, position: 1),
        CurrencyDetails(names: "British Pounds", code: "GBP", symbols: "sterlingsign.circle", isSelected: false, position: 2),
        CurrencyDetails(names: "Indian Rupee", code: "INR", symbols: "indianrupeesign.circle", isSelected: false, position: 3),
        CurrencyDetails(names: "Mexican Peso", code: "MXN", symbols: "pesosign.circle", isSelected: false, position: 4),
        CurrencyDetails(names: "Brazilian Real", code: "BRL", symbols: "brazilianrealsign.circle", isSelected: false, position: 5),
        CurrencyDetails(names: "Japanese Yen", code: "JPY", symbols: "yensign.circle", isSelected: false, position: 6)
    ]
    
//    static var currencyArray: [CurrencyDetails] = [
//        CurrencyDetails(currencyValue: "EUR", position: 0),
//        CurrencyDetails(currencyValue: "USD", position: 1),
//        CurrencyDetails(currencyValue: "GBP", position: 2),
//        CurrencyDetails(currencyValue: "JPY", position: 3),
//        CurrencyDetails(currencyValue: "INR", position: 4),
//        CurrencyDetails(currencyValue: "MXN", position: 5),
//        CurrencyDetails(currencyValue: "BRL", position: 6)
//    ]
    
}

let currencyData: [CurrencyDetails] = [
    CurrencyDetails(names: "Euro", code: "EUR", symbols: "eurosign.circle", isSelected: false, position: 0),
    CurrencyDetails(names: "US Dollar", code: "USD", symbols: "dollarsign.circle", isSelected: false, position: 1),
    CurrencyDetails(names: "British Pounds", code: "GBP", symbols: "sterlingsign.circle", isSelected: false, position: 2),
    CurrencyDetails(names: "Indian Rupee", code: "INR", symbols: "indianrupeesign.circle", isSelected: false, position: 3),
    CurrencyDetails(names: "Mexican Peso", code: "MXN", symbols: "pesosign.circle", isSelected: false, position: 4),
    CurrencyDetails(names: "Brazilian Real", code: "BRL", symbols: "brazilianrealsign.circle", isSelected: false, position: 5),
    CurrencyDetails(names: "Japanese Yen", code: "JPY", symbols: "yensign.circle", isSelected: false, position: 6)
]
