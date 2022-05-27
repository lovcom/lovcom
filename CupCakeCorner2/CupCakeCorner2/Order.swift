//
//  Order.swift
//  CupCakeCorner2
//
//  Created by Dan Lovell on 5/24/22.
//

import SwiftUI

struct Order: Codable {
    static let types = ["Vanilla", "Chocolate", "Strawberry", "Rainbow"]
    
    var type = 0
    var quantity = 3
    var extraFrosting = false
    var addSprinkles = false
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
}
