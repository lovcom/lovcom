//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Dan Lovell on 3/9/22.
//

import Foundation

extension Bundle {
    
    // ********************************************************************
    // * This func extends Bundle, and can be used to convert a JSON file *
    // * to any agreeying struct object.                                  *
    // ********************************************************************
    func decode<T: Codable>(_ file: String) -> T {
        
        // *************************
        // * Locate File in Bundle *
        // *************************
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate file \(file) in bundle.")
        }
        
        // *****************************
        // * Load the File from Bundle *
        // *****************************
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load file \(file) from bundle.")
        }
        
        // ***********************************************************
        // * Convert File JSON data to Instances of struct Astronaut *
        // ***********************************************************
        let decoder = JSONDecoder()
        
        // **********************************
        // * Set Date Formatting            *
        // * If dates are found in the JSON *
        // * they will be formatted as:     *
        // * yy-mm-dd, where these values   *
        // * are zero-padded.               *
        // * This will bring in the dates   *
        // * as real dates; not Strings.    *
        // **********************************
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd" // case-sensitive
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode file \(file) from bundle.")
        }
        
        // **********************************************************
        // * Return Dictionary whose elements are each an Astronaut *
        // **********************************************************
        return loaded
    }
    
}
