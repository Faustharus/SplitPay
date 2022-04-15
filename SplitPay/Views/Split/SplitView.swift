//
//  SplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/03/2022.
//

import SwiftUI

struct SplitView: View {
    
    @State private var amount: Double = 0
    @State private var percentPosition: Int = 0
    let percentage = [0, 10, 15, 20, 25]
    @State private var currencyPosition: Int = 0
    let currencySigns = ["eurosign.circle", "dollarsign.circle", "sterlingsign.circle", "yensign.circle", "indianrupeesign.circle", "pesosign.circle", "brazilianrealsign.circle"]
    let currencyCode = ["EUR", "USD", "GBP", "JPY", "INR", "MXN", "BRL"]
    @State private var numOfPersons = [Double]()
    
    @FocusState private var amountIsFocused: Bool
    
    @State private var indexOfPersons: Double = 0
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        ZStack {
            // Background ???
            
            VStack {
                
                VStack {
                    Picker("", selection: $currencyPosition) {
                        ForEach(0 ..< currencySigns.count, id: \.self) { item in
                            Text("\(currencyCode[item])")
                        }
                    }
                    .pickerStyle(.menu)
                    
                    HStack {
                        Image(systemName: "\(currencySigns[currencyPosition])")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        
                        
                        TextField("\(amount, specifier: "%2.f")", value: $amount, format: .number)
                            .frame(height: 55)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .focused($amountIsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(.black, lineWidth: 3)
                            )
                        
                        
                    }
                }
                .padding(.all, 10)
                
                
                
                // MARK: - Number of Persons
                if sessionService.userDetails.withoutContact {
                HStack {
                    Button(action: {
                        numOfPersons.append(1)
                    }) {
                        Circle()
                            .stroke(.black, lineWidth: 3)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22)
                                    .foregroundColor(.black)
                            )
                    }
                    .padding(.horizontal, 10)

                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(numOfPersons, id: \.self) { item in
                                VStack {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44)
                                    Text("Person")
                                        .font(.subheadline)
                                }
                                .onTapGesture {
                                    numOfPersons.removeAll(keepingCapacity: true)
                                }
                            }
                        }
                    }
                }
                .onAppear(perform: personReset)
                .frame(maxHeight: 66)
                .padding(.all, 15)
                    
                } else {
                    
                    VStack {
                        HStack {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44)
                            TextField("", value: $indexOfPersons, format: .number)
                                .frame(height: 55)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(.black, lineWidth: 3)
                                )
                        }
                    }
                    .onAppear(perform: personReset)
                    .frame(maxHeight: 66)
                    .padding(.all, 10)
                    
                }
                
                // MARK: - Percentage
                Picker("", selection: $percentPosition) {
                    ForEach(0 ..< percentage.count, id: \.self) {
                        Text("\(percentage[$0])%")
                    }
                }
                .pickerStyle(.segmented)
                .padding(.all, 15)
                
                // MARK: - Buttons
                HStack {
                    IconActionButtonView(title: "Creating Group", foreground: .white, background: .blue, sfSymbols: "plus", offsetSymbols: 0.06, handler: {})
                    
                    IconActionButtonView(title: "Reset", foreground: .white, background: .red, sfSymbols: "trash", offsetSymbols: 0.16, handler: {
                        reset()
                    })
                }
                
                Spacer()
                
                NavigationLink {
                    DistributionView()
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "checkmark")
                            .offset(x: UIScreen.main.bounds.width * 0.09, y: -10)
                            .zIndex(1)
                        VStack {
                            Text("Calculating")
                            
                        }
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .frame(maxWidth: 200, maxHeight: 55)
                    .background(amount == 0 || numOfPersons.isEmpty && indexOfPersons == 0 ? .gray : .green)
                    .cornerRadius(7)
                    .padding(.all, 5)
                }
                .disabled(amount == 0 || numOfPersons.isEmpty && indexOfPersons == 0)
                
                Spacer()
                Text("Result in \(Image(systemName: currencySigns[currencyPosition])) : \(sessionService.userDetails.withoutContact ? billArrayWithTips : billWithTips, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                
                Text("Without Tips : \(sessionService.userDetails.withoutContact ? billArrayWithoutTips : billWithoutTips, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                
            }
            .navigationTitle("Split")
            .navigationBarTitleDisplayMode(.inline)
        
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
            .environmentObject(SessionServiceImpl())
    }
}


// MARK: - Computed Prop & Func
extension SplitView {
    
    func reset() {
        amountIsFocused = false
        self.amount = 0.0
        percentPosition = 0
        numOfPersons.removeAll()
        indexOfPersons = 0
    }
    
    func personReset() {
        if sessionService.userDetails.withoutContact {
            indexOfPersons = 0
        } else {
            numOfPersons.removeAll()
        }
    }
    
    var billArrayWithTips: Double {
        let price = amount
        let peopleArrayCount = numOfPersons
        let currentPercent = Double(percentage[percentPosition])

        if peopleArrayCount.isEmpty {
            return 0.0
        } else {
            let priceDivided = price / peopleArrayCount.reduce(0, { x, y in
                x + y
            })
            let priceTiped = priceDivided * (currentPercent / 100.0)
            let result = priceDivided + priceTiped

            return result
        }
    }
    
    var billArrayWithoutTips: Double {
        let price = amount
        let peopleArrayCount = numOfPersons
        
        if peopleArrayCount.isEmpty {
            return 0.0
        } else {
            let priceDivided = price / peopleArrayCount.reduce(0, { x, y in
                x + y
            })
            return priceDivided
        }
    }
    
    var billWithTips: Double {
        let price = amount
        let peopleCount = indexOfPersons
        let currentPercent = Double(percentage[percentPosition])

        if peopleCount == 0.0 {
            return 0.0
        } else {
            let priceDivided = price / peopleCount
            let priceTiped = priceDivided * (currentPercent / 100.0)
            let result = priceDivided + priceTiped

            return result
        }
    }
    
    var billWithoutTips: Double {
        let price = amount
        let peopleCount = indexOfPersons
        
        if peopleCount == 0 {
            return 0.0
        } else {
            let priceDivided = price / peopleCount
            return priceDivided
        }
    }
    
}


// MARK: - View Components
extension SplitView {
    
//    @ViewBuilder
//    var destinationView: some View {
//        if textFieldOrNot {
//            DistributionView()
//        } else {
//            HistoricSplitView()
//        }
//    }
    
}
