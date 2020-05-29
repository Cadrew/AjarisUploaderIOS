//
//  XMLImportDoc.swift
//  AjarisUploaderShare
//
//  Created by user163559 on 5/29/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class XMLImportDoc: NSObject, XMLParserDelegate {
    
    private let recordKey = "upload-result"
    private let dictionaryKeys = Set<String>(["code", "message", "contribution-id"])

    private var results: [[String: String]]?
    private var currentDictionary: [String: String]?
    private var currentAttributes: [String: String]?
    private var currentValue: String?
    
    private let separator: String = "@xml"
    
    init?(data: Data) {
        super.init()
        let dataString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        print(dataString ?? "Failed")
        guard let xmlData = dataString?.data(using: .utf8) else { return nil }
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
        cleanResult()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string + separator
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            results!.append(currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary?[elementName] = currentValue
            currentValue = nil
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)

        currentValue = nil
        currentDictionary = nil
        results = nil
    }
    
    public func getResults() -> [[String: String]]? {
        return self.results
    }
    
    private func cleanResult() {
        if(results == nil) {
            return
        }
        for _ in 0...(separator.count - 1) {
            _ = results![0]["code"] == nil ? " " : results![0]["code"]!.popLast()
            _ = results![0]["message"] == nil ? " " : results![0]["message"]!.popLast()
            _ = results![0]["contribution-id"] == nil ? " " : results![0]["contribution-id"]!.popLast()
        }
    }
}

