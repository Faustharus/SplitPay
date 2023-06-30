//
//  SplitShareView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 26/06/2023.
//

import SwiftUI

struct SplitShareView: View {
    
    @StateObject private var vm = SplitingViewModelImpl(service: SplitingServiceImpl())
    
    @State private var changeCurrency: Bool = false
    
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var minusButton: Bool = false
    @State private var plusButton: Bool = false
    @State private var needToTips: Bool = false
    
    @State private var tapButtonAdd: Bool = false
    
    @State private var isSeeingFriendView: Bool = false
    
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top))
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                DisclosureGroup("Choose a Currency", isExpanded: $changeCurrency) {
                    VStack {
                        ForEach(vm.options, id: \.self) { item in
                            Text(item)
                                .foregroundColor(vm.selectedOptions == item ? .blue : .black)
                                .onTapGesture {
                                    self.vm.selectedOptions = ("\(item)")
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        self.changeCurrency.toggle()
                                    }
                                }
                                .padding(.vertical, 1)
                        }
                    }
                }
                
                ForEach(vm.currencies) { item in
                    if self.vm.selectedOptions == item.names {
                        withAnimation(.spring()) {
                            HStack {
                                Image(systemName: item.symbols)
                                Text(item.names)
                                Spacer()
                                Text("\(splitedAmount, specifier: "%.2f")")
                                Text(item.code)
                            }
                            .font(.system(size: 20, weight: .semibold, design: .serif))
                        }
                    }
                }
                .padding(.vertical, 10)
                
                // MARK: Initial Amount
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(fieldsGradient)
                    VStack(alignment: .center) {
                        Text("Total Amount in \(vm.selectedOptions)")
                            .foregroundColor(.white)
                            .font(.headline)
                        ZStack {
                            TextField("", text: $vm.splitDetails.initialAmount)
                                .focused($isFocused)
                                .keyboardType(.decimalPad)
                                .toolbar {
                                    ToolbarItem(placement: .keyboard) {
                                        HStack {
                                            exitButton
                                            Spacer()
                                            resetButton
                                        }
                                    }
                                }
                            VStack {
                                Text(vm.splitDetails.initialAmount.isEmpty ? "" : "")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    }
                }
                .frame(width: geo.size.width * 0.9, height: 110)
                
                Spacer().frame(height: 26)
                
                // MARK: Number of Persons
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(fieldsGradient)
                    VStack(alignment: .center) {
                        Text("Number of Persons")
                            .foregroundColor(.white)
                            .font(.headline)
                        HStack {
                            StepperCircleButtonView(width: geo.size.width * 0.1, sfSymbols: "minus", isDisabled: vm.splitDetails.indexOfPersons == 1) {
                                minusButton = true
                                vm.splitDetails.indexOfPersons -= 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    minusButton = false
                                }
                            }
                            
                            Spacer()
                            
                            Text("\(vm.splitDetails.indexOfPersons)")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold, design: .default))
                            
                            Spacer()
                            
                            StepperCircleButtonView(width: geo.size.width * 0.1, sfSymbols: "plus", isDisabled: vm.splitDetails.indexOfPersons == 10) {
                                plusButton = true
                                vm.splitDetails.indexOfPersons += 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    plusButton = false
                                }
                            }
                        }
                        .rotation3DEffect(.degrees(5), axis: (x: 0, y: minusButton ? -0.2 : plusButton ? 0.2 : 0, z: 0))
                        .padding(.horizontal, 15)
                    }
                }
                .frame(width: geo.size.width * 0.9, height: 110)
                
                Spacer().frame(height: 26)
                
                // MARK: Tip Percentage
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.black.opacity(0.85).shadow(.drop(color: .black, radius: 5, x: 2, y: -2)))
                    VStack {
                        Toggle(isOn: $needToTips) {
                            Text("Need to Apply a Tip ?")
                                .foregroundColor(.white)
                        }
                        .font(.headline)
                        .padding(.horizontal, 35)
                        .padding(.vertical, 10)
                    }
                }
                .frame(width: geo.size.width * 0.9, height: 55)
                
                VStack {
                    if needToTips {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(.black.opacity(0.35).shadow(.inner(color: .black, radius: 10, x: 0, y: 2)))
                            VStack {
                                Picker("", selection: $vm.splitDetails.percentages) {
                                    ForEach(SplitingDetails.percentArray, id: \.self) {
                                        Text("\($0.reelValue)%")
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal, 15)
                            }
                        }
                    }
                }
                .shadow(color: .gray.opacity(0.35), radius: 10, x: 0, y: -2)
                .offset(x: 0, y: -12.5)
                .zIndex(-1)
                .frame(width: geo.size.width * 0.9, height: 55)
                .transition(transition.animation(.easeInOut(duration: 1.5)))
                
                
                VStack {
                    // MARK: - Button Bottom Page
                    
                    ButtonActionView(tapButton: $tapButtonAdd, title: "Add", foreground: .white, background: [Color.blue.opacity(0.9), Color.blue.opacity(0.6), Color.purple.opacity(0.45)], sfSymbols: "plus", width: geo.size.width * 0.9, height: 65) {
                        animationButton(_tapButtonAdd)
                        vm.addSplitToReview()
                    }
                }
                
            }
            .padding(.horizontal, 15)
        }
        .navigationTitle("Split")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSeeingFriendView = true
                } label: {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
        .fullScreenCover(isPresented: $isSeeingFriendView) {
            NavigationStack {
                FriendSearchView()
            }
        }
    }
}

struct SplitShareView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SplitShareView()
        }
            .environmentObject(SessionServiceImpl())
    }
}

// MARK: - Func & Computed Properties
extension SplitShareView {
    
    func animationButton(_ boolean: State<Bool>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation {
                boolean.wrappedValue = false
            }
        }
        withAnimation {
            boolean.wrappedValue = true
        }
    }
    
    var splitedAmount: Double {
        let price = (vm.splitDetails.initialAmount as NSString).doubleValue
        let peopleCount = vm.splitDetails.indexOfPersons
        let currentPercent = SplitingDetails.percentArray[vm.splitDetails.percentages.position]
        
        let priceDivided = price / Double(peopleCount)
        let priceTiped = priceDivided * (Double(currentPercent.reelValue)) / 100
        let result = priceDivided + priceTiped
        
        return result
    }
    
}

// MARK: - View Components
extension SplitShareView {
    
    var exitButton: some View {
        Button {
            if vm.splitDetails.initialAmount.isEmpty {
                vm.splitDetails.initialAmount = "0.00"
            }
            self.isFocused = false
        } label: {
            Image(systemName: "chevron.left")
            Text("Exit")
        }
        .font(.system(size: 18, weight: .semibold, design: .serif))
        .foregroundColor(.blue)
    }
    
    var resetButton: some View {
        Button {
            vm.splitDetails.initialAmount = ""
        } label: {
            Text("Reset")
            Image(systemName: "trash")
        }
        .font(.headline)
        .foregroundColor(.red)
    }
    
    var fieldsGradient: some ShapeStyle {
        LinearGradient(colors: [Color(red: 0.2, green: 0, blue: 1).opacity(1), Color(red: 0.4, green: 0, blue: 1).opacity(0.8), Color(red: 0.3, green: 0, blue: 0.6).opacity(0.6), Color(red: 0.6, green: 0, blue: 0.8).opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing).shadow(.drop(color: .black, radius: 5, x: 2, y: -2))
    }
    
}
