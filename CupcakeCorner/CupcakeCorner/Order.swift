//
//  Order.swift
//  CupcakeCorner
//
//  Created by Dan Lovell on 5/9/22.
//

import SwiftUI

class Order: ObservableObject, Codable {
    
    // *****************************************
    // * Required for properties marked with   *
    // * @Published property wrapper.          *
    // * Enum defines properties to be Codable *
    // * specialRequestEndabled property not   *
    // * listed here because its a computed    *
    // * value derived from the others.        *
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
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        if streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        if city.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        if zip.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            return false
        }
        
        return true
    }
    
    var cost: Double { // Double is not the best type for currencies, but for now it will do.
        // $2/cupcake
        var cost = Double(quantity) * 2
        
        // Complicated cupcakes cost more
        cost += (Double(type) / 2)
        
        // $1/cupcake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cupcake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
    // ****************************************************************************************
    // * Called automatically by Swift to encode properties using property wrapper @Published *
    // ****************************************************************************************
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
        
    }
    
    // ******************************************************************
    // * This instantiator is required to populate properties from JSON *
    // ******************************************************************
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // **********************************************
        // * Decoding the JSON can be done in any order *
        // **********************************************
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey:    .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
        
    }
    
    // ****************************************************************************
    // * Since Order() is used in lots of places in this app, those places do not *
    // * instantiate with a Decoder type, as is required in the init above.       *
    // * For this reason, this simple init() is added:                            *
    // ****************************************************************************
    init() { }
    
}
