//
//  UserPreferences.swift
//  AjarisUploaderShare
//
//  Created by user163559 on 5/27/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class UserPreferences {
    private static let AjarisPreference: String = "HistoryAjarisUploaderKey"
    private static let defaults = UserDefaults.standard
    
    public static func getPreferences() -> [Contribution] {
        if let saved = defaults.object(forKey: UserPreferences.AjarisPreference) as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode(Array<Contribution>.self, from: saved) {
                return loaded
            }
        }
        return defaults.object(forKey: UserPreferences.AjarisPreference) as? [Contribution] ?? [Contribution]()
    }
}
