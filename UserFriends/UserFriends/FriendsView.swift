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
        VStack {
            List(friendsArray) { friend in // implied: id \.id
                Text("Friend Name: \(friend.unwrappedName)")
                    .font(.caption)
                    .foregroundColor(.purple)
            } // List()
            Spacer()
        } // VStack()
        .navigationBarTitle(Text(userName), displayMode: .inline)
    } // var body
    
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
