//
//  HistoricSplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 13/04/2022.
//

import Firebase
import FirebaseAuth
import SwiftUI

struct HistoricSplitView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var showDetails: Bool = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            List {
                
                ForEach(sessionService.splitArray, id: \.id) { item in
                    NavigationLink {
                        HistoricDetailsSplitView(details: item)
                    } label: {
                        HStack {
                            VStack {
                                HStack {
                                    Text("Currency: ")
                                    Text("\(item.currencyCode)")
                                        .font(.headline)
                                }
                                Text("\(item.entryDate.dateValue().formatted(date: .abbreviated, time: .omitted))")
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Initial Amount:")
                                Text("\(item.initialAmount, specifier: "%.2f")")
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            sessionService.splitDelete(with: Auth.auth().currentUser!.uid, with: item)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .refreshable {
                sessionService.splitRefresh(with: Auth.auth().currentUser!.uid)
            }
            
            ActionButtonView(title: "Delete All", foreground: .white, background: sessionService.splitArray.isEmpty ? .gray : .red, sfSymbols: "trash.fill") {
                sessionService.splitDeleteAll(with: Auth.auth().currentUser!.uid)
            }
            .padding(.horizontal, 10)
            .disabled(sessionService.splitArray.isEmpty)
            
            
        }
    }
}

struct HistoricSplitView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricSplitView()
            .environmentObject(SessionServiceImpl())
    }
}
