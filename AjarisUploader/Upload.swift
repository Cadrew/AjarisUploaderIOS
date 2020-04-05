//
//  Upload.swift
//  AjarisUploader
//
//  Created by user163559 on 4/5/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class Upload: Codable {
    private var file: String = ""
    private var comment: String = ""
    private var profile: Profile = Profile()
    private var date: Date = Date()
    
    init() {
        self.file = ""
        self.comment = ""
        self.profile = Profile()
        self.date = Date()
    }
    
    init(file: String, comment: String, profile: Profile, date: Date) {
        self.file = file
        self.comment = comment
        self.profile = profile
        self.date = date
    }
    
    public func isEmpty() -> Bool {
        return self.file == "" && self.comment == "" && self.profile.isEmpty()
    }
    
    public func getFile() -> String {
        return self.file
    }
    
    public func getComment() -> String {
        return self.comment
    }
    
    public func getProfile() -> Profile {
        return self.profile
    }
    
    public func getDate() -> Date {
        return self.date
    }
}
