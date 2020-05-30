//
//  Upload.swift
//  AjarisUploader
//
//  Created by user163559 on 4/5/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation
import UIKit

class Upload: Codable {
    public var id: Int = -1
    private var file: String = ""
    private var fileData: Data = Data()
    private var comment: String = ""
    private var profile: Profile = Profile()
    private var date: Date = Date()
    
    init() {
        self.id = -1
        self.file = ""
        self.comment = ""
        self.profile = Profile()
        self.date = Date()
    }
    
    init(id: Int, file: String, fileData: Data, comment: String, profile: Profile, date: Date) {
        self.id = id
        self.file = file
        self.comment = comment
        self.profile = profile
        self.date = date
        self.fileData = fileData
    }
    
    public func isEmpty() -> Bool {
        return self.id == -1 && self.file == "" && self.comment == "" && self.profile.isEmpty()
    }
    
    public func getId() -> Int {
        return self.id
    }
    
    public func getFile() -> String {
        return self.file
    }
    
    public func getFileName() -> String {
        var path = self.file.components(separatedBy: "/")
        return path.popLast() ?? ""
    }
    
    public func getUIImage() -> UIImage {
        return UIImage(data: self.fileData) ?? UIImage()
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
    
    public func getDisplayDate() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        return dateFormatterPrint.string(from: self.date)
    }
}
