//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Dan Lovell on 1/30/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
