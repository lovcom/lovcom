//
//  Order.swift
//  CupcakeCorner
//
//  Created by Dan Lovell on 5/9/22.
//

import SwiftUI

class Order: ObservableObject {
    static let types = ["Vanilla", "Chocolate", "Strawberry", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnbaled = false {
        didSet {
            if !specialRequestEnbaled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
}
