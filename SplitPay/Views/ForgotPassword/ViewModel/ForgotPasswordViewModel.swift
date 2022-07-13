//
//  ForgotPasswordViewModel.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 05/05/2022.
//

import Combine
import Foundation

protocol ForgotPasswordViewModel {
    var service: ForgotPasswordService { get }
    var email: String { get }
    init(service: ForgotPasswordService)
    func sendPasswordReset()
}

final class ForgotPasswordViewModelImpl: ObservableObject, ForgotPasswordViewModel {
    
    @Published var email: String = ""
    
    let service: ForgotPasswordService
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: ForgotPasswordService) {
        self.service = service
    }
    
    func sendPasswordReset() {
        service
            .sendPasswordReset(to: email)
            .sink { res in
                switch res {
                // If there an error of any king - break the func and show the error in the console
                case .failure(let err):
                    print("Failed: \(err)")
                default: break
                }
            } receiveValue: {
                print("Sent Password Reset Request")
            }
            .store(in: &subscriptions)
    }
}
