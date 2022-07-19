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
        NavigationView {
            List {
                ForEach(users) { row in
                    NavigationLink {
                        FriendsView(userName: row.unwrappedName, friendsArray: row.friendsArray)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Name: \(row.unwrappedName)")
                                .font(.headline)
                                .foregroundColor(.red)
                            Text("Age: \(String(row.age))")
                                .font(.caption)
                            Text("Company: \(row.unwrappedCompany)")
                                .font(.caption)
                            Text("Number of Friends: \(row.friendsArray.count)")
                                .font(.caption)
                        } // VStack()
                    } // NavigationLink() label
                } // ForEach()
                //.onDelete(perform: deleteUser)
            } // List()
            
            // ********************************************
            // * Inside and at bottom of NavigationView() *
            // ********************************************
            .navigationTitle("Users and Friends") // inside at end of NavigationView
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if users.count == 0 {
                            Task() {
                                await loadData()
                            }
                        }
                    } label: {
                        Label("SaveJSON_Data", systemImage: "plus")
                    }
                } // ToolbarItem()
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if users.count != 0 {
                            Task() {
                                await clearAllUsers(users: users)
                            }
                        }
                    } label: {
                        Label("Clear Persistant Storage", systemImage: "trash")
                    }
                } // ToolbarItem()
                
            } // .toolbar
        } // NavigationView()
        
    } // var body
    
    // *************************************************
    // * Load Data from JSON into Tables User & Friend *
    // *************************************************
    func loadData() async {
        
        print("**************************")
        print("* func loadData() Evoked *")
        print("**************************")
        
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
                await clearAllUsers(users: users)
                
                // ***************************************************
                // * Insert decoded data into Tables User and Friend *
                // ***************************************************
                await writeJSON_ToPersistentStores(results: results)
                
                
            } else {
                print("Decoding of JSON failed")
            }
            
        } catch {
            print("Invalid JSON data")
        }
    } // loadData()
    
    // *******************
    // * Clear all Users *
    // *******************
    func clearAllUsers(users: FetchedResults<User>) async {
        print("*******************************")
        print("* func clearAllUsers() Evoked *")
        print("* userCount is \(users.count)            *")
        print("*******************************")
        
        var userCount: Int = 0
        
        for user in users {
            moc.delete(user)
            userCount += 1
        }
        
        // ******************************************
        // * If Deletions were made, commit changes *
        // ******************************************
        if moc.hasChanges {
            
            do {
                try moc.save() // Write RAM data to Persistent Storage
                print("Number of Users Deleted: \(userCount)")
            } catch {
                print("moc.save() for deletion failed")
            }
        }
        
    } // clearAllUsers()
    
    // ********************************************************
    // * Write JSON Data to Persistent tables User and Friend *
    // ********************************************************
    func writeJSON_ToPersistentStores(results: [Results]) async {
        print("********************************")
        print("* Add JSON Data to User Stores *")
        print("********************************")
        var arrayUsers = [User]()
        var nextUser: Int = -1
        var numberOfUsersWritten = 0
        var numberofUsersWriteError = 0
        
        for user in results {
            // *******************************************
            // * Create New User inside Array arrayUsers *
            // *******************************************
            nextUser += 1
            arrayUsers.insert(User(context: moc), at: nextUser)
            
            arrayUsers[nextUser].id = UUID()
            arrayUsers[nextUser].name = user.name
            arrayUsers[nextUser].age = Int16(user.age)
            arrayUsers[nextUser].company = user.company
            arrayUsers[nextUser].friends = []
            
            // *********************************************
            // * Create Friend Rows for User (many to one) *
            // *********************************************
            var arrayUserFriends = [Friend]()
            var nextFriend = -1
            
            for friend in user.friends {
                nextFriend += 1
                arrayUserFriends.insert(Friend(context: moc), at: nextFriend)
                
                arrayUserFriends[nextFriend].id = UUID()
                arrayUserFriends[nextFriend].name = friend.name
                arrayUserFriends[nextFriend].user = arrayUsers[nextUser]
                arrayUsers[nextUser].friends?.adding(arrayUserFriends[nextFriend])
            }
            
            // **************************************
            // * Save New User to Persistant Stores *
            // **************************************
            if moc.hasChanges {
                
                do {
                    try moc.save() // Write RAM data to Persistent Storage
                    numberOfUsersWritten += 1
                } catch {
                    print("moc.save() failed")
                    numberofUsersWriteError += 1
                }
                
            }
            
        }
        
        print("*************************")
        print("* loadData Process Done *")
        print("* Success Writes: \(numberOfUsersWritten)   *")
        print("* Error Writes: \(numberofUsersWriteError)       *")
        print("*************************")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
