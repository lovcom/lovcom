// ********************************************************************
// * This playground demonstrantes how a file in an app's bundle can  *
// * be written to an app's persistant Storage Partition playground   *
// ********************************************************************
//import UIKit // This is needed for FileManager Class and it's methods
import SwiftUI // OR: This is needed for FileManager Class and it's methods

// ****************************************
// * Create Instance of FileManager Class *
// ****************************************
let manager = FileManager.default

// **************************************
// * The Data to be Written to New File *
// **************************************
let myFileData = "This is test data for my new file".data(using: .utf8)

// **********************
// * File To Be Created *
// **********************
let file = "MyTestFile.txt"

// ****************************************************
// * Get App's storage Partition Directory Last Entry *
// ****************************************************
guard let documentsDirectoryLastEntryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last  else {
    fatalError("Could not get last Documents Directory Entry.")
}

print(documentsDirectoryLastEntryURL)

// *****************************************************
// * Get URL for New File Entry in Documents Directory *
// *****************************************************
let fileURL = documentsDirectoryLastEntryURL.appendingPathComponent(file)

// **************************
// * Write Data to New File *
// **************************
manager.createFile(atPath: fileURL.path, contents: myFileData, attributes: [:])

// ***********************************************
// * Read File Data from App's Storage Partition *
// ***********************************************
let readFileFromAppStoragePartition = try String(contentsOf: fileURL)
print("Data from file found in App's Storage Partition Bytes: \(readFileFromAppStoragePartition)")
print("Logic executed successfully.")
