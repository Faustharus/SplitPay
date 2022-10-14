//
//  FriendRequestViewModel.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/09/2022.
//

import Combine
import Foundation
import SwiftUI

enum FriendState {
    case sent
    case received
    case failed(error: Error)
    case na
}

protocol FriendRequestViewModel {
    //var friendRequest: FriendRequest { get }
    var state: FriendState { get }
    var service: FriendRequestService { get }
    init(service: FriendRequestService)
    func makeNewRequest(with userUid: String)
}

final class FriendRequestViewModelImpl: ObservableObject, FriendRequestViewModel {
    
    //@Published var friendRequest: FriendRequest = FriendRequest.new
    @Published var state: FriendState = FriendState.na
    //@Published var isFriended: Bool = false
    
    let service: FriendRequestService
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: FriendRequestService) {
        self.service = service
    }
    
    func makeNewRequest(with userUid: String) {
        service
            .makeRequest(with: userUid)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .sent
            }
            .store(in: &subscriptions)
    }
    
}
