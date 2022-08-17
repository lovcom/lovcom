//
//  FileManager-JSON.swift
//  Moonshot
//
//  Created by Dan Lovell on 8/15/22.
//

import Foundation

extension FileManager {
    
    // *****************************************************
    // * Write File from Bundle to App's Storage Partition *
    // *****************************************************
    func writeFileFromBundleToFileManager(_ file: String) -> Bool {
        
        // ********************
        // * Get App's Bundle *
        // ********************
        let appBundle = Bundle.main
        
        // *************************
        // * Locate File in Bundle *
        // *************************
        guard let urlOfFileInBundle = appBundle.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to find file \(file) in bundle.")
        }
        
        // *****************************
        // * Load the File from Bundle *
        // *****************************
        guard let data = try? Data(contentsOf: urlOfFileInBundle) else {
            fatalError("Failed to load file \(file) from bundle.")
        }
        
        // ***************************************
        // * Get App's Partition Directory Entry *
        // ***************************************
        let appPartitionStorageEntryURL = getAppDirectoryEntry().appendingPathComponent(file)
        
        // *****************************************
        // * Write file to App's Storage Partition *
        // *****************************************
        do {
            try str.write(to: appPartitionStorageEntryURL, atomically: true, encoding: .utf8)
        } catch {
           return false
        }
        
        return true
    }
    
    // ********************************************************
    // * Return directory of files in app's Storage Partition *
    // ********************************************************
    func getAppDirectoryEntry() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0] // return first directory entry
    }
    
}
