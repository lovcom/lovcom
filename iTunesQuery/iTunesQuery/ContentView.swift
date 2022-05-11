//
//  ContentView.swift
//  iTunesQuery
//
//  Created by Dan Lovell on 5/2/22.
//

import SwiftUI

// **************************************************************************
// * Use Structs to Define a JSON array results containing Results elements *
// **************************************************************************
struct Response: Codable {
    var results: [Results]
}

struct Results: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [Results]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
                    .font(.caption)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        
        // ****************************
        // * Confirm the URL is Valid *
        // ****************************
        guard let url = URL(string: "https://itunes.apple.com/search?term=led+zepplin&entity=song") else {
            print("Invalid URL")
            return
        }
        
        // *****************************************
        // * Call the URL, receiving back Response *
        // *****************************************
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // ************************
            // * Unpack JSON response *
            // ************************
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
            
        } catch {
            print("Invalid data")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
