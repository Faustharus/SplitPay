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
    case percentage
    case initialAmount
    case splitedAmount
    case indexOfPersons
}

protocol SplitingService {
    func storing(with details: SplitingDetails) -> AnyPublisher<Void, Error>
}

final class SplitingServiceImpl: SplitingService {
    func storing(with details: SplitingDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                if let uid = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).collection("review").document("doc\(UUID().uuidString)").setData([
                        SplitingKeys.initialAmount.rawValue: details.initialAmount,
                        SplitingKeys.splitedAmount.rawValue: details.initialAmount / details.indexOfPersons,
                        SplitingKeys.currencyCode.rawValue: details.currencyCode,
                        SplitingKeys.percentage.rawValue: details.percentage,
                        SplitingKeys.indexOfPersons.rawValue: details.indexOfPersons
                    ]) { error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
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
