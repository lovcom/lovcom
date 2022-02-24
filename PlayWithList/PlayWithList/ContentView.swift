//
//  ContentView.swift
//  PlayWithList
//
//  Created by Dan Lovell on 2/19/22.
//

import SwiftUI

struct ContentView: View {
    @State private var numbers = [23, 43, 44, 65, 99, 334, 543, 223, 89, 0, 55, 44]
    
    var body: some View {
        List {
            ForEach(numbers, id: \.self) {
                Text("Hello World \($0)")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
