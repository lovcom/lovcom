//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Dan Lovell on 4/30/22.
//

import SwiftUI

class User: ObservableObject, Codable {
    var song = "The Song Remains the Same"
    @Published var name = "Paul Hudson"
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
