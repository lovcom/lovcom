//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Dan Lovell on 1/30/23.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    
    // *****************************************************
    // * This class is modified with @MainActor, so that...*
    // *****************************************************
    @MainActor class ViewModel: ObservableObject {
        
        // ***********************************************************************************
        // * This class is instantiated into a property having modifier @StateObject so that *
        // * published values here can be viewed there.                                      *
        // ***********************************************************************************
        @Published  var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25 ))
        @Published  private(set) var locations: [Location]
        @Published  var selectedPlace: Location?
        @Published var isUnlocked = false
        
        // *****************************************************************************
        // * This will create the JSON file "SavedPlaces" if it does not already exist *
        // *****************************************************************************
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        // ***********************************************************************************************************
        // * This initializer will attempt to load saved places from a JSON document in iCloud called "SavedPlaces". *
        // ***********************************************************************************************************
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = [] // empty array
            }
        }
        
        // ***************************************************************************
        // * This func will save array locations to a JSON file called "SavedPlaces" *
        // ***************************************************************************
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection]) // .completeFileProtection insures written data is encrypted in the strongest ways
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticateError in
                    if success {
                        // **********************************************************************************************************
                        // * Eventhough we specified @MainActor for class ViewModel, because Apple's own code was used to deal with *
                        // * authentication in this func, @MainActor for this class was not respected when setting self.isUnlocked  *
                        // * to true.  The solution is to place that inside a Task enclosure as shown below.                        *
                        // **********************************************************************************************************
                        
                        // self.isUnlocked = true
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        print("Failed to authenticate")
                    }
                }
            } else {
                print("No biometrics on device")
            }
        }
        
    }
    
}
