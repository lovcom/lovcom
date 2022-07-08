//
//  Friend+CoreDataProperties.swift
//  UserFriends
//
//  Created by Dan Lovell on 7/7/22.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var user: User?
    
    public var unwrappedId: String {
        id ?? "Unknown id"
    }
    
    public var unwrappedName: String {
        name ?? "Unknown name"
    }

}

extension Friend : Identifiable {

}
