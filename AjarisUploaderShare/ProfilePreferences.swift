//
//  UserPreferences.swift
//  AjarisUploaderShare
//
//  Created by user163559 on 5/27/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class ProfilePreferences {
    private static let AjarisPreference: String = "AjarisUploaderKey"
    private static let defaults = UserDefaults(suiteName: "com.orkis.ajarisuploader")
    
    public static func getPreferences() -> [Profile] {
        if let saved = defaults?.object(forKey: ProfilePreferences.AjarisPreference) as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode(Array<Profile>.self, from: saved) {
                return loaded
            }
        }
        return defaults?.object(forKey: ProfilePreferences.AjarisPreference) as? [Profile] ?? [Profile]()
    }
}
