//
//  Base.swift
//  AjarisUploaderShare
//
//  Created by user163559 on 5/27/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class Base: Codable {
    private var id: Int = 0
    private var label: String = ""
    
    init() {
        self.id = 0
        self.label = ""
    }
    
    init(id: Int, label: String) {
        self.id = id
        self.label = label
    }
    
    public func isEmpty() -> Bool {
        return self.id == 0 && self.label == ""
    }
    
    public func getId() -> Int {
        return self.id
    }
    
    public func getLabel() -> String {
        return self.label
    }
    
    public func toString() -> String {
        let separator = "&base"
        return String(self.id) + separator + self.label
    }
}

