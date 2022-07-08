//
//  UserFriendsApp.swift
//  UserFriends
//
//  Created by Dan Lovell on 6/27/22.
//

import SwiftUI

@main
struct UserFriendsApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
