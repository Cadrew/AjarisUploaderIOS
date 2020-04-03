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
    private let dictionaryKeys = Set<String>(["error-code", "error-message", "imports", "bases", "sessionid", "ptoken"])

    private var results: [[String: String]]?
    private var currentDictionary: [String: String]?
    private var currentValue: String?
    private var bases: [String] = []
    private var imports: [String] = []
    
    private let separator: String = "@xml"
    private let defaultField: String = "Par défaut"
    
    init?(data: Data) {
        super.init()
        var dataString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // TODO: remove test
        //dataString = "<result><error-code>0</error-code><error-message></error-message><sessionid>69D52E170930DEF8B6D4B4FDDC2B8BBF</sessionid><ptoken>1Na-Tt-28qqZDlFWWYAgD959yuuCYNVhqii7gHzcePMph243wCkRBxBg6lknppROqn9xJ6VpW0ABAVT0yEeorZpKtRtO80OXdJjdn4jFzact0I</ptoken><webapp-version>6.3.0-20056</webapp-version><bases><name num=\"7\">7 - Test</name><name num=\"7\">8 - Test</name><name num=\"6\">6 - Generique</name></bases><imports><name>Defaut</name></imports><uploadmaxfilesize>5000M</uploadmaxfilesize></result>"
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
            bases.insert(defaultField, at: 0)
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
            imports.insert(defaultField, at: 0)
        }
    }
}
