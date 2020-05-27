//
//  UploadPreferences.swift
//  AjarisUploaderShare
//
//  Created by user163559 on 5/27/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class UploadPreferences {
    private static let AjarisPreference: String = "HistoryAjarisUploaderKey"
    private static let defaults = UserDefaults(suiteName: "com.orkis.ajarisuploader")
    
    public static func getPreferences() -> [Contribution] {
        if let saved = defaults?.object(forKey: UploadPreferences.AjarisPreference) as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode(Array<Contribution>.self, from: saved) {
                return loaded
            }
        }
        return defaults?.object(forKey: UploadPreferences.AjarisPreference) as? [Contribution] ?? [Contribution]()
    }
    
    public static func savePreferences(contributions: [Contribution]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contributions) {
            defaults?.set(encoded, forKey: UploadPreferences.AjarisPreference)
        }
    }
    
    public static func addPreferences(contribution: Contribution) {
        if(contribution.isEmpty()) {
            return
        }
        var isAlreadyIn = false
        var contributions = UploadPreferences.getPreferences()
        if(contributions.count == 0) {
            contribution.id = 0
        } else {
            for i in 0...contributions.count - 1 {
                if(contributions[i].getId() == contribution.getId()) {
                    contribution.id = 0
                    contributions[i] = contribution
                    isAlreadyIn = true
                    break
                }
                contributions[i].id = contributions[i].id + 1
            }
        }
        if(!isAlreadyIn) {
            contributions.append(contribution)
        }
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

