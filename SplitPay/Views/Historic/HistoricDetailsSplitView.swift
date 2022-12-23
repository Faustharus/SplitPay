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
        ScrollView {
            VStack(spacing: 10) {
                HStack {
                    Text("Currency :")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(currencyName)
                        .font(.headline)
                        .bold()
                        .italic()
//                    Image(systemName: currencySymbol)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 44, height: 44)
                    
                    Spacer()
                    Divider()
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("\(details.entryDate.dateValue().formatted(date: .abbreviated, time: .omitted)),")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Text("\(details.entryDate.dateValue().formatted(date: .omitted, time: .standard))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding()
                
                HStack {
                    Text("Number of Persons :")
                    Text("\(details.indexOfPersons)")
                        .italic()
                }
                .font(.headline)
                
                HStack {
                    Text("Percentage Rate :")
                    Text("\(details.percentages) %")
                }
                
                HStack {
                    VStack {
                        Text("Total Amount :")
                        HStack {
                            Text("\(details.initialAmount, specifier: "%.2f")")
                            Image(systemName: currencySign)
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Your Split :")
                        HStack {
                            Text("\(details.splitedAmount, specifier: "%.2f")")
                            Image(systemName: currencySign)
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("With Tips :")
                        HStack {
                            Text("\(splitWithTips - details.splitedAmount, specifier: "%.2f")")
                            Image(systemName: currencySign)
                        }
                    }
                    
                }
                .padding()
                
                VStack {
                    Text("Names :")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0 ..< 10) { item in
                                VStack {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                    Text("Name \(item)")
                                }
                            }
                            .padding(.horizontal, 6)
                        }
                    }
                    
                }
                .frame(height: 100)
                .padding()
                
                Button {
                    // TODO: More Code Later
                } label: {
                    HStack {
                        Text("Export as PDF")
                        Image(systemName: "doc.badge.arrow.up")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                    }
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 60)
                    .background(Color.blue)
                    .cornerRadius(7)
                    
                }
                
            }
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
    
    var currencySign: String {
        switch details.currencyCode {
        case "EUR":
            return "eurosign"
        case "GBP":
            return "sterlingsign"
        case "JPY":
            return "yensign"
        case "INR":
            return "indianrupeesign"
        case "MXN":
            return "pesosign"
        case "BRL":
            return "brazilianrealsign"
        default:
            return "dollarsign"
        }
    }
    
    var currencyName: String {
        switch details.currencyCode {
        case "EUR":
            return "EUR"
        case "GBP":
            return "GBP"
        case "JPY":
            return "JPY"
        case "INR":
            return "INR"
        case "MXN":
            return "MXN"
        case "BRL":
            return "BRL"
        default:
            return "USD"
        }
    }
    
}
