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
            List(friendsArray) { friend in // implied: id \.id
                Text(friend.unwrappedName)
                    .font(.body)
                    .foregroundColor(.purple)
            } // List()
            Spacer() // this pushes everything to the top
        } // VStack()
        .navigationBarTitle(Text("\(userName) Friends"), displayMode: .inline)
    } // var body
    
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
