//
//  SplitingViewModel.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 18/04/2022.
//

import Combine
import Foundation

enum SplitState {
    case successfull
    case failed(error: Error)
    case na
}

protocol SplitingViewModel {
    var splitDetails: SplitingDetails { get }
    var state: SplitState { get }
    var service: SplitingService { get }
    init(service: SplitingService)
    func addSplitToReview()
}

final class SplitingViewModelImpl: ObservableObject, SplitingViewModel {
    
    @Published var splitDetails: SplitingDetails = SplitingDetails.new
    @Published var state: SplitState = .na
    @Published var currencies: [CurrencyDetails] = currencyData
    
    var options = ["Euro", "US Dollar", "British Pounds", "Indian Rupee", "Mexican Peso", "Brazilian Real", "Japanese Yen"]
    
    var selectedOptions: String {
        didSet {
            currencies = currencyData.filter { $0.names == selectedOptions }
        }
    }
    
    let service: SplitingService
    
    private var subsciptions = Set<AnyCancellable>()
    
    init(service: SplitingService) {
        self.service = service
        selectedOptions = options[0]
    }
    
    func addSplitToReview() {
        service
            .storing(with: splitDetails, splitDetails.currencyCode)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subsciptions)
    }
    
}
