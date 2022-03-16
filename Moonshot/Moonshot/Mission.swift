//
//  Mission.swift
//  Moonshot
//
//  Created by Dan Lovell on 3/9/22.
//

import Foundation

struct Mission: Codable, Identifiable {
    
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
       "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    // ***************************************************
    // * Render date in correct format for user's locale *
    // ***************************************************
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
}
