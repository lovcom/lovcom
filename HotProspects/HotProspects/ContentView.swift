//
//  ContentView.swift
//  HotProspects
//
//  Created by Dan Lovell on 2/22/23.
//

import SwiftUI

// Define class User as an observable object to be published
@MainActor class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

// Create 2 Views that reference an environmental object user to be
// placed there from inside the ContentView.
struct EditView: View {
    @EnvironmentObject var user: User // not instantiatd yet
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User // not instantiatd yet
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct ContentView: View {
    @StateObject var user = User() // this is where user is created
    
    var body: some View {
        VStack {  // Notice that there are 2 ways to inject object user into the environment
            //EditView().environmentObject(user)
            //DisplayView().environmentObject(user)
            EditView() // because of modifier .environmentObject(user) below, we can do cleaner calls
            DisplayView()
        }
        .environmentObject(user) // this is where user is injected into the environment
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
