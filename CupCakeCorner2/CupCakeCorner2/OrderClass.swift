//
//  OrderClass.swift
//  CupCakeCorner2
//
//  Created by Dan Lovell on 5/24/22.
//

import SwiftUI

class OrderClass: ObservableObject, Codable {
    
    // *****************************************
    // * Enum defines properties to be Codable *
    // * specialRequestEndabled property not   *
    // * listed here because its a computed    *
    // * value derived from the others (not    *
    // * represented in the JSON).             *
    // *****************************************
    enum CodingKeys: CodingKey {
        case type
        case quantity
        case extraFrosting
        case addSprinkles
        case name
        case streetAddress
        case city
        case zip
    }
    
    // ************************
    // * Define Watched State *
    // ************************
    @Published var order: Order = Order()
    
    @Published var specialRequestEnbaled = false {
        didSet {
            if !specialRequestEnbaled {
                order.extraFrosting = false
                order.addSprinkles = false
            }
        }
    }
    
    var hasValidAddress: Bool {
        
        if order.name.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        if order.streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        if order.city.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        if order.zip.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        return true
    }
    
    var cost: Double { // Double is not the best type for currencies, but for now it will do.
        // $2/cupcake
        var cost = Double(order.quantity) * 2
        
        // Complicated cupcakes cost more
        cost += (Double(order.type) / 2)
        
        // $1/cupcake for extra frosting
        if order.extraFrosting {
            cost += Double(order.quantity)
        }
        
        // $0.50/cupcake for sprinkles
        if order.addSprinkles {
            cost += Double(order.quantity) / 2
        }
        
        return cost
    }

    // **************************************************************
    // * Called automatically by Swift to encode properties to JSON *
    // **************************************************************
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(order.type, forKey: .type)
        try container.encode(order.quantity, forKey: .quantity)
        try container.encode(order.extraFrosting, forKey: .extraFrosting)
        try container.encode(order.addSprinkles, forKey: .addSprinkles)
        try container.encode(order.name, forKey: .name)
        try container.encode(order.streetAddress, forKey: .streetAddress)
        try container.encode(order.city, forKey: .city)
        try container.encode(order.zip, forKey: .zip)
        
    }
    
    // ******************************************************************
    // * This instantiator is required to populate properties from JSON *
    // ******************************************************************
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // **********************************************
        // * Decoding the JSON can be done in any order *
        // **********************************************
        order.type = try container.decode(Int.self, forKey: .type)
        order.quantity = try container.decode(Int.self, forKey: .quantity)
        order.extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        order.addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        order.name = try container.decode(String.self, forKey:    .name)
        order.streetAddress = try container.decode(String.self, forKey: .streetAddress)
        order.city = try container.decode(String.self, forKey: .city)
        order.zip = try container.decode(String.self, forKey: .zip)
        
    }
    
    // *********************************************************************************
    // * Since OrderClass() is used in lots of places in this app, those places do not *
    // * instantiate with a Decoder type, as is required in the init above.            *
    // * For this reason, this simple init() is added:                                 *
    // *********************************************************************************
    init() { }
    
}
