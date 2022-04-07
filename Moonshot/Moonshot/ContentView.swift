//
//  ContentView.swift
//  Moonshot
//
//  Created by Dan Lovell on 3/1/22.
//

import SwiftUI

struct ContentView: View {
    
    // ***************************************
    // * Convert JSON data to struct objects *
    // ***************************************
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json") // Dictionary
    let missions: [Mission] = Bundle.main.decode("missions.json") // Array of Missions
    
    // *************************************************************
    // * Define the Columns to be used with a LazyVGrid View below *
    // * They are defined as adaptive so that the View can be used *
    // * on many different Apple devices, and look good.           *
    // *************************************************************
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: astronauts) // Evoked Full-Screen View
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                VStack {
                                    
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground) // Custom defined: Color-Theme.swift
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackground) // Custom defined: Color-Theme.swift
                            )
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground) // Custom defined: Color-Theme.swift
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
