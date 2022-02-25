//
//  ContentView.swift
//  WeSplit
//
//  Created by Dan Lovell on 1/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0 // this effects the Picker starting selection below
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    private let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2) // based 0 values; see below
        return (checkAmount + (checkAmount / 100 * Double(tipPercentage))) / peopleCount
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) { // can be from two diners to 100 diners
                            Text("\($0) people") // 0 based, so 2 is 0, 3 is 1, n is n - 2
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented) // %s listed horizontally in segments
                } header: { // Section header title
                    Text("How much tip do you want to leave?")
                        .foregroundColor(tipPercentage == 0 ? .red : .blue)
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: { // Section header title
                    Text("Total amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
