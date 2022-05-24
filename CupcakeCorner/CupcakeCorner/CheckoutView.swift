//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Dan Lovell on 5/10/22.
//

import SwiftUI


enum placeOrderErrors: Error {
    case successful
    case failedToEncodeOrder
    case checkoutFailed
    case invalidURL
    case invalidHTTP_Header
    case REST_RequestFailed
    case unpackingJSON_ResponseFailed
}

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingHTTP_Error   = false
    @State private var errorMessage        = ""
    
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
                        
                        do {
                            showingConfirmation = try await placeOrder()
                        } catch placeOrderErrors.invalidURL {
                            showingHTTP_Error = true
                            errorMessage = "Order failed because URL invalid."
                        } catch placeOrderErrors.failedToEncodeOrder {
                            showingHTTP_Error = true
                            errorMessage = "Order failed because problem converting Order to JSON."
                        } catch placeOrderErrors.invalidHTTP_Header {
                            showingHTTP_Error = true
                            errorMessage = "Order failed because HTTP Header specified is invalid."
                        } catch placeOrderErrors.REST_RequestFailed {
                            showingHTTP_Error = true
                            errorMessage = "REST POSTS HTTP Request failed. Service might be down or URL misspelled?"
                        } catch placeOrderErrors.checkoutFailed {
                            showingHTTP_Error = true
                            errorMessage = "Order checkout failed. Call support."
                        }
                        catch {
                            showingHTTP_Error = true
                            errorMessage = "Catch All: Order failed because something went wrong."
                        }
                        
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
        
        .alert("HTTP Error", isPresented: $showingHTTP_Error) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    
    func placeOrder() async throws -> Bool {
        
        var response: Data = Data()
        var decodedOrder: Order = Order()
        
        confirmationMessage = ""
        
        // ********************************************************************
        // * Encode order object into JSON and place JSON in constant encoded *
        // ********************************************************************
        guard let encoded = try? JSONEncoder().encode(order) else {
            throw placeOrderErrors.failedToEncodeOrder
        }
        
        // *************************************************************************************
        // * Define Request URL. Request made to a generic testing server https://reqres.in... *
        // * This testing server can be used for anything. It will return a response that is   *
        // * the same as the request.                                                          *
        // *************************************************************************************
        guard let url = URL(string: "https://reqres.in/api/cupcakes") else {
            throw placeOrderErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        // *********************************
        // * Define HTTP Header Values     *
        // * These values are forgiving if *
        // * junk values specified, but    *
        // * the impact could be felt when *
        // * the REST service is called    *
        // * below.                        *
        // *********************************
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // *********************************
        // * Perform the REST POST Request *
        // *********************************
        do {
            (response, _) = try await URLSession.shared.upload(for: request, from: encoded)
        } catch {
            throw placeOrderErrors.REST_RequestFailed
        }
        
        // ********************************************
        // * Convert JSON Response to an Order object *
        // ********************************************
        do {
            decodedOrder = try JSONDecoder().decode(Order.self, from: response)
        } catch {
            throw placeOrderErrors.unpackingJSON_ResponseFailed
        }
        
        // ******************************************************
        // * Set confirmation message for an alert dialogue box *
        // ******************************************************
        confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
        return true
    }
    
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
