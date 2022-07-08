//
//  ContentView.swift
//  UserFriends
//
//  Created by Dan Lovell on 6/27/22.
//

import SwiftUI

// ****************************
// * Define the Response JSON *
// ****************************

// ***********************************************************************************************
// * Notice that this JSON array does not show inside the root {  }, which is not often the case *
// ***********************************************************************************************

//[
//    {
//        "id": "50a48fa3-2c0f-4397-ac50-64da464f9954",
//        "isActive": false,
//        "name": "Alford Rodriguez",
//        "age": 21,
//        "company": "Imkan",
//        "email": "alfordrodriguez@imkan.com",
//        "address": "907 Nelson Street, Cotopaxi, South Dakota, 5913",
//        "about": "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.",
//        "registered": "2015-11-10T01:47:18-00:00",
//        "tags": [
//            "cillum",
//            "consequat",
//            "deserunt",
//            "nostrud",
//            "eiusmod",
//            "minim",
//            "tempor"
//        ],
//        "friends": [
//            {
//                "id": "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0",
//                "name": "Hawkins Patel"
//            },
//            {
//                "id": "0c395a95-57e2-4d53-b4f6-9b9e46a32cf6",
//                "name": "Jewel Sexton" ......
struct Results: Codable {
    let id: String
    let name: String
    let age: Int
    let company: String
    let friends: [Friend]
    
    struct Friend: Codable {
        let id: String
        let name: String
    }
    
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var results = [Results]()
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)]) var users: FetchedResults<User>
    
    var body: some View {
        
        List(users, id: \.id) { row in
            VStack(alignment: .leading) {
                Text("Name: \(row.unwrappedName)")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("Age: \(String(row.age))")
                    .font(.caption)
                Text("Company: \(row.unwrappedCompany)")
                    .font(.caption)
                
                ForEach(row.friendsArray) { friend in
                    Text("Friend Name: \(friend.unwrappedName)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
            }
            
        }
        
        // **************************************************************
        // * Load Data into persistent tables User and Friend from JSON *
        // **************************************************************
        .task(priority: .high) {
            await loadData()
        }
    }
    
    // *************************************************
    // * Load Data from JSON into Tables User & Friend *
    // *************************************************
    func loadData() async {
        
        // ****************************
        // * Confirm the URL is Valid *
        // ****************************
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        // *************************************************
        // * Call the Web service, receiving back Response *
        // *************************************************
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // ************************
            // * Decode JSON response *
            // ************************
            if let decodedResponse = try? JSONDecoder().decode([Results].self, from: data) {
                results = decodedResponse
                
                // ********************************
                // * Clear User and Friend Tables *
                // ********************************
                for user in users {
                    moc.delete(user)
                }
                
                // ******************************************
                // * If Deletions were made, commit changes *
                // ******************************************
                if moc.hasChanges {
                    
                    do {
                        try moc.save() // Write RAM data to Persistent Storage
                    } catch {
                        print("moc.save() for deletion failed")
                    }
                }
                
                // ***************************************************
                // * Insert decoded data into Tables User and Friend *
                // ***************************************************
                for user in results {
                    
                    // ***********************
                    // * Create New User Row *
                    // ***********************
                    let newUser = User(context: moc)
                    
                    newUser.id = user.id
                    newUser.name = user.name
                    newUser.age = Int16(user.age)
                    newUser.company = user.company
                    
                    // *********************************************
                    // * Create Friend Rows for User (many to one) *
                    // *********************************************
                    for friend in user.friends {
                        let newFriend = Friend(context: moc)
                        
                        newFriend.id = friend.id
                        newFriend.name = friend.name
                        newFriend.user = newUser
                    }
                    
                }
                
                // ***************************************************************
                // * If Inserts were made to User and Friend tables, commit them *
                // ***************************************************************
                if moc.hasChanges {
                    print("DB Has Changes")
                    
                    do {
                        try moc.save() // Write RAM data to Persistent Storage
                    } catch {
                        print("moc.save() failed")
                    }
                }
                
            } else {
                print("Decoding of JSON failed")
            }
            
        } catch {
            print("Invalid JSON data")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
