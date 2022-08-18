// ******************************************************************
// * This playground demostrants how a file in an app's bundle can  *
// * be written to an app's persistant Storage Partition playground *
// ******************************************************************
import UIKit // This is needed for FileManager Class and it's methods

// ******************************
// * File To Be Found in Bundle *
// ******************************
let file = "astronauts.json"

// *************************
// * Locate File in Bundle *
// *************************
guard let urlOfFileInBundle = Bundle.main.url(forResource: file, withExtension: nil) else {
    fatalError("Could not locate file \(file) in app's bundle.")
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
        print("Data for File \(file) is reachable.")
    } else {
        print("Data for File \(file) is NOT reachable.")
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
    let readFileFromAppStoragePartition = try String(contentsOf: appPartitionStorageEntryURL)
    print("Data from file found in App's Storage Partition Bytes: \(readFileFromAppStoragePartition.count)")
    print("Logic executed successfully.")
    
} catch {
    fatalError(error.localizedDescription)
}
