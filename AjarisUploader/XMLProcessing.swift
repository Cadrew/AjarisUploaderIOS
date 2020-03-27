//
//  XMLProcessing.swift
//  AjarisUploader
//
//  Created by user163559 on 3/27/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class XMLProcessing: NSObject, XMLParserDelegate {
    
    private let recordKey = "result"
    private let dictionaryKeys = Set<String>(["error-code", "error-message"])

    private var results: [[String: String]]?
    private var currentDictionary: [String: String]?
    private var currentValue: String?
    
    init?(data: Data) {
        super.init()
        let dataString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        print(dataString ?? "Failed")
        guard let xmlData = dataString?.data(using: .utf8) else { return nil }
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        if parser.parse() {
            print(self.results ?? "No results")
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }

    // start element
    //
    // - If we're starting a "record" create the dictionary that will hold the results
    // - If we're starting one of our dictionary keys, initialize `currentValue` (otherwise leave `nil`)

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }

    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }

    // end element
    //
    // - If we're at the end of the whole dictionary, then save that dictionary in our array
    // - If we're at the end of an element that belongs in the dictionary, then save that value in the dictionary

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            results!.append(currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary![elementName] = currentValue
            currentValue = nil
        }
    }

    /*
     Affiche l'erreur lors d'un parsing, s'il y en a une
     */
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)

        currentValue = nil
        currentDictionary = nil
        results = nil
    }
}
