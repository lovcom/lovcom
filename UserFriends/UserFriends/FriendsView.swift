//
//  FriendsView.swift
//  UserFriends
//
//  Created by Dan Lovell on 7/18/22.
//

import SwiftUI

struct FriendsView: View {
    let userName: String
    let friendsArray: [Friend]
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(friendsArray) { friend in // implied: id \.id
                    Text(friend.unwrappedName)
                        .font(.body)
                        .foregroundColor(.purple)
                } // ForEach()
                .onDelete(perform: deleteFriend)
            } // List()
            Spacer() // this pushes everything to the top
        } // VStack()
        .navigationBarTitle(Text("\(userName) Friends"), displayMode: .inline)
    } // var body
  
    // *****************************************
    // * Delete friends which are swipped left *
    // *****************************************
    func deleteFriend(at offsets: IndexSet) {
        
        for offset in offsets {
            let friend = friendsArray[offset]
            moc.delete(friend)
        }
        
        if moc.hasChanges {
            try? moc.save()
        }
        
    } // func deleteFriend
    
}
