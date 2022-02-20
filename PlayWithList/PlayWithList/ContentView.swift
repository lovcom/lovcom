//
//  ContentView.swift
//  PlayWithList
//
//  Created by Dan Lovell on 2/19/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Text("Hello World 01")
                .foregroundColor(.blue)
            Text("Hello World 02")
                .foregroundColor(.red)
            Text("Hello World 03")
                .foregroundColor(.green)
            Text("Hello World 04")
                .foregroundColor(.yellow)
            Text("Hello World 05")
                .foregroundColor(.orange)
            Text("Hello World 06")
                .foregroundColor(.purple)
            Text("Hello World 07")
                .foregroundColor(.white)
                .background(.black)
            Text("Hello World 08")
                .foregroundColor(.brown)
            Text("Hello World 09")
                .foregroundColor(.cyan)
            Text("Hello World 10")
                .foregroundColor(.teal)
            // Text("Hello World 11") 11th view not possible
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
