//
//  ForgotPasswordService.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 05/05/2022.
//

import Combine
import Foundation
import FirebaseAuth

protocol ForgotPasswordService {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error>
}

final class ForgotPasswordServiceImpl: ForgotPasswordService {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                // Initialize the Authentication
                Auth
                    .auth()
                    // Send a request by email for a new password
                    .sendPasswordReset(withEmail: email) { error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
