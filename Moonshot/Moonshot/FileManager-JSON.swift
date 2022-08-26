//
//  FileManager-JSON.swift
//  Moonshot
//
//  Created by Dan Lovell on 8/15/22.
//

import Foundation
import UIKit // This brings in FileManager Class functionality

extension FileManager {
    
    // *****************************************************
    // * Write File from Bundle to App's Storage Partition *
    // *****************************************************
    static func writeFileFromBundleToFileManager(_ file: String) -> URL {
        
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
        
        // **************************************************
        // * Convert contents of file from Bundle to String *
        // **************************************************
        guard let fileInBundleData = try? String(contentsOf: urlOfFileInBundle) else {
            fatalError("Could not open bundle file \(file) via its url for conversion to String.")
        }
        
        // ****************************************************
        // * Get App's storage Partition Directory Last Entry *
        // ****************************************************
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last  else {
            fatalError("Could not get last Documents Directory Entry.")
        }

        // **************************************
        // * Append File Entry To the Directory *
        // **************************************
        let appPartitionStorageEntryURL = documentsDirectory.appendingPathComponent(file)
        print("Appended File to Directory OK.")

        // *****************************************
        // * Write Data to App's Storage Partition *
        // *****************************************
        do {
            // *********************************************************
            // * Determine if Data Already Exists for File (reachable) *
            // *********************************************************
            var dataExists = false
            
            if let _ = try? appPartitionStorageEntryURL.checkResourceIsReachable() {
                dataExists = true
                print("Data for File \(file) exists already.")
            } else {
                print("Data for File \(file) does not exist yet.")
            }
            
            // *****************************************
            // * If file has no data, write data to it *
            // *****************************************
            if !dataExists {
                try fileInBundleData.write(to: appPartitionStorageEntryURL, atomically: true, encoding: .utf8)
                print("For File \(file) in App's Storage Partition, data was written to.")
            }
            
            // ***********************************************
            // * Read File Data from App's Storage Partition *
            // ***********************************************
            let stringDataFromStoragePartition = try String(contentsOf: appPartitionStorageEntryURL)
            print("Data from file found in App's Storage Partition Bytes: \(stringDataFromStoragePartition.count)")
            print("Logic executed successfully.")
            return appPartitionStorageEntryURL
            
        } catch {
            fatalError(error.localizedDescription)
        }
 
    }
    
}
