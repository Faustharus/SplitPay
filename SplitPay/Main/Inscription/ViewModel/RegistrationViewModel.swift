//
//  RegistrationViewModel.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 09/04/2022.
//

import Combine
import Foundation

enum RegistrationState {
    case successfull
    case failed(error: Error)
    case na
}

protocol RegistrationViewModel {
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var userDetails: RegistrationDetails { get }
    init(service: RegistrationService)
    func register()
}

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    
    @Published var state: RegistrationState = .na
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    
    private var subscriptions = Set<AnyCancellable>()
    
    let service: RegistrationService
    
    init(service: RegistrationService) {
        self.service = service
    }
    
    func register() {
        service
            .register(with: userDetails)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
    
    
    
    
}
