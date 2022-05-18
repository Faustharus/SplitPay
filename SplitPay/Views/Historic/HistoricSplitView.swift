//
//  HistoricSplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 13/04/2022.
//

import FirebaseAuth
import SwiftUI

struct HistoricSplitView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        List(sessionService.splitArray) { item in
                
                VStack {
                    HStack {
                        VStack {
                            Text("\(item.entryDate.dateValue().formatted(date: .abbreviated, time: .omitted))")
                                .font(.system(size: 12, weight: .light, design: .serif))
                            Text("\(item.entryDate.dateValue().formatted(date: .omitted, time: .standard))")
                                .font(.system(size: 14, weight: .regular, design: .serif))
                        }
                        
                        Spacer()
                            .frame(maxWidth: 50)
                        
                        Text("Currency: \(item.currencyCode)")
                    }
                    .font(.system(.headline))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Initial Amount: \(item.initialAmount, specifier: "%.2f")")
                            Text("Percentage Applied: \(item.percentages) %")
                        }
                        Rectangle()
                            .frame(width: 1, height: 50)
                            .foregroundColor(.gray)
                        
                        Text("N° of Persons: \(item.indexOfPersons)")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("Splited Amount: \(item.splitedAmount, specifier: "%.2f")")
                        Button(action: {
                            sessionService.splitDelete(with: Auth.auth().currentUser!.uid, with: item)
                        }) {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 33, height: 33)
                                .foregroundColor(.red)
                        }
                    }
                }
                
            
        }
        .refreshable {
            sessionService.splitRefresh(with: Auth.auth().currentUser!.uid)
        }
    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct HistoricSplitView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricSplitView()
            .environmentObject(SessionServiceImpl())
    }
}
