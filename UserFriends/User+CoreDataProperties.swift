//
//  User+CoreDataProperties.swift
//  UserFriends
//
//  Created by Dan Lovell on 7/7/22.
//
//

import Foundation
import CoreData

// ***************************************************
// * Auto-Created by CoreData from Data Model screen *
// ***************************************************
extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var friends: NSSet?

    public var unwrappedCompany: String {
        company ?? "Unknown Company"
    }
    
    public var unwrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var unwrappedId: UUID {
        id ?? UUID()
    }
    
    public var friendsArray: [Friend] {
        let set = friends as? Set<Friend> ?? []
        
        return set.sorted {
            $0.unwrappedName < $1.unwrappedName
        }
    }
}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User : Identifiable {

}
