//
//  HistoricDetailsSplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/04/2022.
//

import SwiftUI

struct HistoricDetailsSplitView: View {
    let currencyName: String
    let initialAmount: Double
    let percentageApplied: Int
    let nbOfPersons: Int
    let splitedAmount: Double
    
    var body: some View {
        VStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(.black, lineWidth: 3)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 5)
                    .shadow(color: .black, radius: 5, x: 1, y: 10)
                VStack {
                    HStack {
                        Text("\(Date().formatted())")
                        
                        Spacer()
                            .frame(maxWidth: 50)
                        
                        Text("Currency: \(currencyName)")
                    }
                    .font(.system(.headline))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Initial Amount: \(initialAmount, specifier: "%.2f") €")
                            Text("Percentage Applied: \(percentageApplied) %")
                        }
                        Rectangle()
                            .frame(width: 1, height: 50)
                            .foregroundColor(.gray)
                        
                        Text("N° of Persons: \(nbOfPersons, specifier: "%g")")
                    }
                    .padding(.vertical, 10)
                    
                    Text("Splited Amount: \(splitedAmount, specifier: "%.2f") €")
                }
            }
            
        }
    }
}

struct HistoricDetailsSplitView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricDetailsSplitView(currencyName: "EUR", initialAmount: 200, percentageApplied: 20, nbOfPersons: 6, splitedAmount: 40)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
