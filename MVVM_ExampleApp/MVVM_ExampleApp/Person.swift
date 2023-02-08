//
//  Person.swift
//  MVVM_ExampleApp
//
//  Created by Dan Lovell on 1/23/23.
//

import SwiftUI

struct Person: Identifiable {
    var id = UUID()
    var name: String
    var email: String
    var phoneNumber: String
}
