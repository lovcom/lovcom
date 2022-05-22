//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Dan Lovell on 5/10/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3)
                { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 233)
                
                Text("Your total cost \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order") {
                    Task { // Must wrap call to asynch inside Task
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        
        // ********************************************************************
        // * Encode order object into JSON and place JSON in constant encoded *
        // ********************************************************************
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        // *************************************************************************************
        // * Define Request URL. Request made to a generic testing server https://reqres.in... *
        // * This testing server can be used for anything. It will return a response that is   *
        // * the same as the request.                                                          *
        // *************************************************************************************
        let url = URL(string: "https://reqres.in/api/cupcakes")! // Force unpack optional
        var request = URLRequest(url: url)
        
        // *****************************
        // * Define HTTP Header Values *
        // *****************************
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // *********************************
        // * Perform the REST POST Request *
        // *********************************
        do {
            let (response, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // ********************************************
            // * Convert JSON Response to an Order object *
            // ********************************************
            let decodedOrder = try JSONDecoder().decode(Order.self, from: response)
            
            // ******************************************************
            // * Set confirmation message for an alert dialogue box *
            // ******************************************************
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch { // Catch any errors
            print("Checkout failed.")
        }
        
    }
    
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
