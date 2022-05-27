//
//  ContentView.swift
//  CupCakeCorner2
//
//  Created by Dan Lovell on 5/24/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var orderClass: OrderClass = OrderClass()
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    Picker("Select your cake type", selection: $orderClass.order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(orderClass.order.quantity)", value: $orderClass.order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $orderClass.specialRequestEnbaled.animation())
                    
                    if orderClass.specialRequestEnbaled {
                        Toggle("Add extra frosting?", isOn: $orderClass.order.extraFrosting)
                        Toggle("Add extra sprinkles?", isOn: $orderClass.order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(orderClass: orderClass)
                        
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
