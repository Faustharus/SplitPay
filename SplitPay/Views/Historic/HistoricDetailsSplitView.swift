//
//  HistoricDetailsSplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 20/05/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HistoricDetailsSplitView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @Environment(\.presentationMode) var presentationMode
    
    let details: SessionSplitUserDetails
    
    var body: some View {
        VStack {
            Text("Date : \(details.entryDate.dateValue().formatted(date: .abbreviated, time: .standard))")
            Text("Initial Amount : \(details.initialAmount, specifier: "%.2f")")
            Text("Splited Amount with Tips : \(splitWithTips, specifier: "%.2f")")

        }
    }
}

struct HistoricDetailsSplitView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricDetailsSplitView(details: SessionSplitUserDetails(initialAmount: 0.00, percentages: 0, currencyCode: "", indexOfPersons: 0, splitedAmount: 0.00, entryDate: Timestamp(date: Date.now)))
            .environmentObject(SessionServiceImpl())
    }
}

// MARK: - Computed Properties
extension HistoricDetailsSplitView {
    
    var splitWithTips: Double {
        let price = details.initialAmount
        let peopleCount = details.indexOfPersons
        let currentPercent = details.percentages

        if peopleCount == 0 {
            return 0.0
        } else {
            let priceDivided = price / Double(peopleCount)
            let priceTiped = priceDivided * (Double(currentPercent) / 100.0)
            let result = priceDivided + priceTiped
            
            return result
        }
    }
    
}
