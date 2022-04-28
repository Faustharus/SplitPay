//
//  SplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/03/2022.
//

import SwiftUI

struct SplitView: View {
    
    @StateObject private var vm = SplitingViewModelImpl(service: SplitingServiceImpl())
    
    @State private var amount: Double = 0
    @State private var percentPosition: Int = 0
    let percentage = [0, 10, 15, 20, 25]
    @State private var currencyPosition: Int = 0
    let currencySigns = ["eurosign.circle", "dollarsign.circle", "sterlingsign.circle", "yensign.circle", "indianrupeesign.circle", "pesosign.circle", "brazilianrealsign.circle"]
    let currencyCode = ["EUR", "USD", "GBP", "JPY", "INR", "MXN", "BRL"]
    @State private var numOfPersons = [Double]()
    
    @FocusState private var amountIsFocused: Bool
    
    //@State private var indexOfPersons: Double = 0
    
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
                        
                        
                        TextField("\(vm.splitDetails.initialAmount, specifier: "%2.f")", value: $vm.splitDetails.initialAmount, format: .number)
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
                if sessionService.userDetails.withContact {
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
                            TextField("", value: $vm.splitDetails.indexOfPersons, format: .number)
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
                Picker("", selection: $vm.splitDetails.percentage) {
                    ForEach(0 ..< percentage.count, id: \.self) { item in
                        Text("\(percentage[item])%")
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
                
                IconActionButtonView(title: "Storing", foreground: .white, background: .purple, sfSymbols: "folder", offsetSymbols: 0.14, handler: {
                    vm.addSplitToReview()
                })
                
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
                    .background(vm.splitDetails.initialAmount == 0 || numOfPersons.isEmpty && vm.splitDetails.indexOfPersons == 0 ? .gray : .green)
                    .cornerRadius(7)
                    .padding(.all, 5)
                }
                .disabled(vm.splitDetails.initialAmount == 0 || numOfPersons.isEmpty && vm.splitDetails.indexOfPersons == 0)
                
                Spacer()
                Text("Result in \(Image(systemName: currencySigns[currencyPosition])) : \(sessionService.userDetails.withContact ? billArrayWithTips : billWithTips, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                
                Text("Without Tips : \(sessionService.userDetails.withContact ? billArrayWithoutTips : billWithoutTips, specifier: "%.2f")")
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
        vm.splitDetails.initialAmount = 0.0
        vm.splitDetails.percentage = 0
        vm.splitDetails.indexOfPersons = 0.0
        numOfPersons.removeAll()
//        amountIsFocused = false
//        self.amount = 0.0
//        percentPosition = 0
//        numOfPersons.removeAll()
//        indexOfPersons = 0
    }
    
    func personReset() {
        if sessionService.userDetails.withContact {
            vm.splitDetails.indexOfPersons = 0.0
            //indexOfPersons = 0
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
        let price = vm.splitDetails.initialAmount
        let peopleCount = vm.splitDetails.indexOfPersons
        let currentPercent = Double(percentage[vm.splitDetails.percentage])

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
        let price = vm.splitDetails.initialAmount
        let peopleCount = vm.splitDetails.indexOfPersons
        
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
