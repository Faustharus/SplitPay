//
//  LoginViewModel.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Combine
import Foundation

enum LoginState {
    case successfull
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    var service: LoginService { get }
    var state: LoginState { get }
    var credentials: LoginCredentials { get }
    init(service: LoginService)
    func login()
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    
    @Published var state: LoginState = .na
    @Published var credentials: LoginCredentials = LoginCredentials.new
    @Published var hasError: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    let service: LoginService
    
    init(service: LoginService) {
        self.service = service
        setupErrorConnection()
    }
    
    func login() {
        service
            .login(with: credentials)
            .sink { res in
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
    
}

private extension LoginViewModelImpl {
    
    func setupErrorConnection() {
        $state
            .map { state -> Bool in
                switch state {
                    case .successfull,
                            .na:
                        return false
                    case .failed:
                        return true
                }
            }
            .assign(to: &$hasError)
    }
    
}
