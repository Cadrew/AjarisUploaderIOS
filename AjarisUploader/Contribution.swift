//
//  Contribution.swift
//  AjarisUploader
//
//  Created by user163559 on 4/5/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class Contribution: Codable {
    public var id: Int = -1
    private var uploads: [Upload] = []
    
    init() {
        self.id = -1
        self.uploads = []
    }
    
    init(id: Int, uploads: [Upload]) {
        self.id = id
        self.uploads = uploads
    }
    
    public func getId() -> Int {
        return self.id
    }
    
    public func getUploads() -> [Upload] {
        return self.uploads
    }
    
    public func getNumberOfuploads() -> Int {
        return self.uploads.count
    }
    
    public func isEmpty() -> Bool {
        return self.id == -1 && self.uploads.isEmpty
    }
    
    public static func getContributionById(contributions: [Contribution], id: Int) -> Contribution {
        for contribution in contributions {
            if(contribution.getId() == id) {
                return contribution
            }
        }
        return Contribution()
    }
}
