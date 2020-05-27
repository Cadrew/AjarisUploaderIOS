//
//  ProfilePreferences.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
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
    
    public static func savePreferences(profiles: [Profile]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            defaults?.set(encoded, forKey: ProfilePreferences.AjarisPreference)
        }
    }
    
    public static func addPreferences(profile: Profile) {
        if(profile.isEmpty()) {
            return
        }
        var profiles = ProfilePreferences.getPreferences()
        profiles.append(profile)
        ProfilePreferences.savePreferences(profiles: profiles)
    }
    
    public static func removePreference(profile: Profile) {
        var profiles = ProfilePreferences.getPreferences()
        var index = -1
        for i in 0...profiles.count - 1 {
            if(profiles[i].getId() == profile.getId()) {
                index = i
                break
            }
        }
        if(index == -1) {
            return
        }
        profiles.remove(at: index)
        ProfilePreferences.savePreferences(profiles: profiles)
    }
    
    public static func removeAllPreferences() {
        ProfilePreferences.savePreferences(profiles: [Profile]())
    }
}
