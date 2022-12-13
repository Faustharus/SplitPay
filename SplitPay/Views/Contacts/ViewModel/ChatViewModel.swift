//
//  ChatViewModel.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/12/2022.
//

import Combine
import Foundation
import SwiftUI

enum ChatState {
    case successfull
    case failed(error: Error)
    case na
}

protocol ChatViewModel {
    var chatMessage: ChatDetails { get }
    var state: ChatState { get }
    var service: ChatService { get }
    init(service: ChatService)
    func sendNewMessage(with toUid: String?, and model: ChatDetails)
}

final class ChatViewModelImpl: ObservableObject, ChatViewModel {
    
    @Published var chatMessage: ChatDetails = ChatDetails.new
    @Published var state: ChatState = .na
    @Published var toUid: String = ""
    
    let service: ChatService
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: ChatService) {
        self.service = service
    }
    
    func sendNewMessage(with toUid: String?, and model: ChatDetails) {
        service
            .sendMessage(with: toUid, and: chatMessage)
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
