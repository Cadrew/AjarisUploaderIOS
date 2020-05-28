//
//  Profile.swift
//  AjarisUploaderShare
//
//  Created by user163559 on 5/27/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class Profile: Codable {
    public var id: Int = -1
    private var name: String = ""
    private var login: String = ""
    private var url: String = ""
    private var pwd: String = ""
    private var base: Base = Base()
    private var importProfile: String = ""
    
    init() {
        self.id = -1
        self.name = ""
        self.login = ""
        self.url = ""
        self.pwd = ""
        self.base = Base()
        self.importProfile = ""
    }
    
    init(id: Int, name: String, login: String, pwd: String, url: String, base: Base, importProfile: String) {
        self.id = id
        self.name = name
        self.login = login
        self.url = url
        self.pwd = pwd
        self.base = base
        self.importProfile = importProfile
    }
    
    public func isEmpty() -> Bool {
        return self.id == -1 && self.name == "" && self.login == "" && self.url == "" && self.pwd == "" && self.base.isEmpty() && self.importProfile == ""
    }
    
    public func getId() -> Int {
        return self.id
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getLogin() -> String {
        return self.login
    }
    
    public func getUrl() -> String {
        return self.url
    }
    
    public func getBase() -> Base {
        return self.base
    }
    
    public func getImportProfile() -> String {
        return self.importProfile
    }
    
    public func getPwd() -> String {
        return self.pwd
    }
    
    public func toString() -> String {
        let separator = "&profile"
        return String(self.id) + separator + self.name + separator + self.url + separator + self.login + separator + self.pwd + separator + self.base.toString() + separator + self.importProfile
    }
    
    public func equal(profile: Profile) -> Bool {
        return self.id == profile.getId() && self.name == profile.getName() && self.login == profile.getLogin() && self.url == profile.getUrl() && self.pwd == profile.getPwd()
    }
}
