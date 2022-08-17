//
//  ContentView.swift
//  BucketList
//
//  Created by Dan Lovell on 8/9/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                let str = "Test Message"
                // create file message.txt
                let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                
                do {
                    // Write data to file message.txt
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    
                    // read data from file message.txt
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    // Print caught error
                    print(error.localizedDescription)
                }
                
            }
    }
    
    // Return directory of files in app's partition
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    
    
}
