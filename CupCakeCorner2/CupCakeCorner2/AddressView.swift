//
//  AddressView.swift
//  CupCakeCorner2
//
//  Created by Dan Lovell on 5/24/22.
//

import SwiftUI

struct AddressView: View {
    @StateObject var orderClass: OrderClass
    
    var body: some View {
        Form {
            
            Section {
                TextField("Name", text: $orderClass.order.name)
                TextField("Street Address", text: $orderClass.order.streetAddress)
                TextField("City", text: $orderClass.order.city)
                TextField("Zip", text: $orderClass.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(orderClass: orderClass)
                } label: {
                    Text("Check Out")
                }
            }
            .disabled(!orderClass.hasValidAddress)
            
        }
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(orderClass: OrderClass())
    }
}
