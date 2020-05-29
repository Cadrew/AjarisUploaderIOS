//
//  XMLProcessing.swift
//  AjarisUploaderShare
//
//  Created by user163559 on 5/28/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class XMLProcessing: NSObject, XMLParserDelegate {
    
    private let recordKey = "result"
    private let dictionaryKeys = Set<String>(["error-code", "error-message", "imports", "bases", "sessionid", "ptoken", "uploadmaxfilesize"])

    private var results: [[String: String]]?
    private var currentDictionary: [String: String]?
    private var currentAttributes: [String: String]?
    private var currentValue: String?
    private var bases: [String] = []
    private var basesNum: [Int] = []
    private var imports: [String] = []
    
    private let separator: String = "@xml"
    public static let DefaultField: String = "Par défaut"
    
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
        if attributeDict.count != 0 && elementName == "name" && (attributeDict["num"] != nil) {
            basesNum.append(Int(attributeDict["num"] ?? "") ?? 0)
        }
    }

    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string + separator
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
    
    public func getResults() -> [[String: String]]? {
        return self.results
    }
    
    public func getBases() -> [String] {
        return self.bases
    }
    
    public func getImports() -> [String] {
        return self.imports
    }
    
    public func getBasesNum() -> [Int] {
        return self.basesNum
    }
    
    public func getUploadMaxFileSize()-> Int {
        _ = results![0]["uploadmaxfilesize"] == nil ? " " : results![0]["uploadmaxfilesize"]!.popLast()
        return Int(self.results![0]["uploadmaxfilesize"]!)! * 1000 * 1000
    }
    
    private func cleanResult() {
        if(results == nil) {
            return
        }
        for _ in 0...(separator.count - 1) {
            _ = results![0]["error-code"] == nil ? " " : results![0]["error-code"]!.popLast()
            _ = results![0]["error-message"] == nil ? " " : results![0]["error-message"]!.popLast()
            _ = results![0]["bases"] == nil ? " " : results![0]["bases"]!.popLast()
            _ = results![0]["bimportsases"] == nil ? " " : results![0]["imports"]!.popLast()
            _ = results![0]["sessionid"] == nil ? " " : results![0]["sessionid"]!.popLast()
            _ = results![0]["ptoken"] == nil ? " " : results![0]["ptoken"]!.popLast()
            _ = results![0]["uploadmaxfilesize"] == nil ? " " : results![0]["uploadmaxfilesize"]!.popLast()
        }
        if(results![0]["bases"] != nil) {
            results![0]["bases"] = results![0]["bases"]!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let b = results![0]["bases"]!.components(separatedBy: separator)
            for var a in b {
                a = a.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if(a.isEmpty || a == "") {
                    continue
                }
                bases.append(a)
            }
        }
        if(bases.count > 1) {
            bases.insert(XMLProcessing.DefaultField, at: 0)
        }
        if(results![0]["imports"] != nil) {
            results![0]["imports"] = results![0]["imports"]!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let b = results![0]["imports"]!.components(separatedBy: separator)
            for var a in b {
                a = a.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if(a.isEmpty || a == "") {
                    continue
                }
                imports.append(a)
            }
        }
        if(imports.count > 1) {
            imports.insert(XMLProcessing.DefaultField, at: 0)
        }
    }
}

