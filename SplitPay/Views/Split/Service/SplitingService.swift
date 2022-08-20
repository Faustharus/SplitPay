//
//  SplitingService.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 18/04/2022.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

enum SplitingKeys: String {
    case currencyCode
    case percentages
    case initialAmount
    case splitedAmount
    case indexOfPersons
    case entryDate
}

protocol SplitingService {
    func storing(with details: SplitingDetails, _ currencyDetails: [CurrencyDetails]) -> AnyPublisher<Void, Error>
}

final class SplitingServiceImpl: SplitingService {
    func storing(with details: SplitingDetails, _ currencyDetails: [CurrencyDetails]) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                // Check if the user is connected
                if let uid = Auth.auth().currentUser?.uid {
                    // Initialize the DB
                    let db = Firestore.firestore()
                    // Add a new document in the Collection named "review"
                    db.collection("users").document(uid).collection("review").addDocument(data: [
                        SplitingKeys.initialAmount.rawValue: details.initialAmount,
                        SplitingKeys.splitedAmount.rawValue: details.initialAmount / Double(details.indexOfPersons),
                        SplitingKeys.currencyCode.rawValue: currencyDetails[0].code,
                        SplitingKeys.percentages.rawValue: details.percentages.reelValue,
                        SplitingKeys.indexOfPersons.rawValue: details.indexOfPersons,
                        SplitingKeys.entryDate.rawValue: Timestamp(date: Date.now)
                    ]) { error in
                        if let err = error {
                            // Display an error if there an issue
                            promise(.failure(err))
                        } else {
                            // Let the process continue if the process run'd smoothly
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "Invalid Entered Split Data", code: 1, userInfo: nil)))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    // MARK: - Re-purposed as an Edit function
//    func storing(with details: SplitingDetails) -> AnyPublisher<Void, Error> {
//        Deferred {
//            Future { promise in
//                if let uid = Auth.auth().currentUser?.uid {
//                    let db = Firestore.firestore()
//                    db.collection("users").document(uid).collection("review").document("doc\(details.id)").setData([
//                        SplitingKeys.initialAmount.rawValue: details.initialAmount,
//                        SplitingKeys.splitedAmount.rawValue: details.initialAmount / Double(details.indexOfPersons),
//                        SplitingKeys.currencyCode.rawValue: details.currencyCode.currencyValue,
//                        SplitingKeys.percentages.rawValue: details.percentages.reelValue,
//                        SplitingKeys.indexOfPersons.rawValue: details.indexOfPersons
//                    ], merge: false) { error in
//                        if let err = error {
//                            promise(.failure(err))
//                        } else {
//                            promise(.success(()))
//                            print("\(String(describing: details.id))")
//                        }
//                    }
//                } else {
//                    promise(.failure(NSError(domain: "Invalid Entered Split Data", code: 1, userInfo: nil)))
//                }
//
//
//            }
//        }
//        .receive(on: RunLoop.main)
//        .eraseToAnyPublisher()
//    }
    
//    var billWithTips: Double {
//        let price = vm.splitDetails.initialAmount
//        let peopleCount = vm.splitDetails.indexOfPersons
//        let currentPercent = Double(percentage[vm.splitDetails.percentage])
//
//        if peopleCount == 0.0 {
//            return 0.0
//        } else {
//            let priceDivided = price / peopleCount
//            let priceTiped = priceDivided * (currentPercent / 100.0)
//            let result = priceDivided + priceTiped
//
//            return result
//        }
//    }
    
}
