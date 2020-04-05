//
//  UploadPreferences.swift
//  AjarisUploader
//
//  Created by user163559 on 4/5/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class UploadPreferences {
    private static let AjarisPreference: String = "HistoryAjarisUploaderKey"
    private static let defaults = UserDefaults.standard
    
    public static func getPreferences() -> [Contribution] {
        if let saved = defaults.object(forKey: UploadPreferences.AjarisPreference) as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode(Array<Contribution>.self, from: saved) {
                return loaded
            }
        }
        return defaults.object(forKey: UploadPreferences.AjarisPreference) as? [Contribution] ?? [Contribution]()
    }
    
    public static func savePreferences(contributions: [Contribution]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contributions) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UploadPreferences.AjarisPreference)
        }
    }
    
    public static func addPreferences(contribution: Contribution) {
        if(contribution.isEmpty()) {
            return
        }
        var contributions = UploadPreferences.getPreferences()
        contributions.append(contribution)
        UploadPreferences.savePreferences(contributions: contributions)
    }
    
    public static func removePreference(contribution: Contribution) {
        var contributions = UploadPreferences.getPreferences()
        var index = -1
        for i in 0...contributions.count - 1 {
            if(contributions[i].getId() == contribution.getId()) {
                index = i
                break
            }
        }
        if(index == -1) {
            return
        }
        contributions.remove(at: index)
        UploadPreferences.savePreferences(contributions: contributions)
    }
    
    public static func removeAllPreferences() {
        UploadPreferences.savePreferences(contributions: [Contribution]())
    }
}
