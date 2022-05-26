//
//  RegistrationService.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum RegistrationKeys: String {
    case firstName
    case surName
    case nickName
    case extNickName
    case profilePicture
    case email
    case withContact
}

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .createUser(withEmail: details.email, password: details.password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                
                                let db = Firestore.firestore()
                                db.collection("users").document(uid).setData([
                                    RegistrationKeys.firstName.rawValue: details.firstName,
                                    RegistrationKeys.surName.rawValue: details.surName,
                                    RegistrationKeys.nickName.rawValue: details.nickName,
                                    RegistrationKeys.extNickName.rawValue: "\(details.nickName)#\(Int.random(in: 1000..<9999))",
                                    RegistrationKeys.profilePicture.rawValue: details.profilePicture,
                                    RegistrationKeys.email.rawValue: details.email,
                                    RegistrationKeys.withContact.rawValue: details.withContact
                                ]) { error in
                                    if let err = error {
                                        promise(.failure(err))
                                    } else {
                                        promise(.success(()))
                                    }
                                }
                                    
                                
                            } else {
                                promise(.failure(NSError(domain: "Invalid User ID", code: 0, userInfo: nil)))
                            }
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
