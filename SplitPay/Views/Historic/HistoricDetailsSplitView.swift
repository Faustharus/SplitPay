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
            HStack {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.black, lineWidth: 3)
                    .frame(width: 100, height: 100)
                    .overlay(
                        VStack {
                            Text("Currency :")
                                .font(.headline)
                            Image(systemName: currencySymbol)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                        }
                )
                
                Spacer().frame(width: UIScreen.main.bounds.midX - 80)
                
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.black, lineWidth: 3)
                    .frame(width: 150, height: 100)
                    .overlay(
                        VStack {
                            Text("Percentage Applied :")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 1)
                            Text("\(details.percentages) %")
                                .font(.headline.weight(.bold))
                        }
                    )
            }
            
            RoundedRectangle(cornerRadius: 25)
                .stroke(.black, lineWidth: 3)
                .frame(width: 200, height: 200)
                .overlay(
                    VStack {
                        Text("Date: \(details.entryDate.dateValue().formatted(date: .abbreviated, time: .standard))")
                            .font(.system(size: 14, weight: .semibold, design: .serif))
                        Text("The rest of the infos")
                            .font(.headline)
                    }
                )
            
            
            
//            Text("Date : \(details.entryDate.dateValue().formatted(date: .abbreviated, time: .standard))")
//            HStack {
//                Text("Currency : ")
//                Image(systemName: currencySymbol)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 44, height: 44)
//            }
//            Text("Initial Amount : \(details.initialAmount, specifier: "%.2f")")
//            Text("Number of Persons : \(details.indexOfPersons)")
//            Text("Price Percentage Applied : \(details.percentages)")
//            Text("Splited Amount without Tips : \(details.splitedAmount, specifier: "%.2f")")
//            Text("Splited Amount with Tips : \(splitWithTips, specifier: "%.2f")")
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
    
    var currencySymbol: String {
        switch details.currencyCode {
        case "EUR":
            return "eurosign.circle"
        case "GBP":
            return "sterlingsign.circle"
        case "JPY":
            return "yensign.circle"
        case "INR":
            return "indianrupeesign.circle"
        case "MXN":
            return "pesosign.circle"
        case "BRL":
            return "brazilianrealsign.circle"
        default:
            return "dollarsign.circle"
        }
    }
    
}
