//
//  DataController.swift
//  Bookworm
//
//  Created by Dan Lovell on 5/26/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    // *******************************************************************
    // * Prepare Bookworm Data Model for subsequent Load in another step *
    // * This involved registering the Data Model to a new Container.    *
    // * Data Model does not contain the actual data.                    *
    // *******************************************************************
    let container = NSPersistentContainer(name: "Bookworm")
    
    // ***************************************************
    // * Load the Database from the harddrive to RAM.    *
    // * Most apps only use 1 persistent store.          *
    // * This step loads the actual data from persistent *
    // * storage to RAM.                                 *
    // ***************************************************
    init() {
        container.loadPersistentStores {description, error in
            if let error = error {
                print("CoreData failed to load Bookworm data: \(error.localizedDescription)")
            }
        }
    }
    
    
}
