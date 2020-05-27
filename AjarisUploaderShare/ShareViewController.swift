//
//  ShareViewController.swift
//  AjarisUploaderShare
//
//  Created by user168808 on 3/28/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Alamofire

class ShareViewController: SLComposeServiceViewController {
    
    var imageType = ""
    var sc_uploadURL = "https://demo-interne.ajaris.com/Demo/upImportDoc.do"
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func configurationItems() -> [Any]! {
       // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let item = SLComposeSheetConfigurationItem()!
        item.title = "Test"
        item.value = "Value"
        item.tapHandler = self.show
        print("Bonjour")
        return [item]
    }

    func show() {
        print("TEST")
    }
        
    func upload(imgData: Data, jsessionid: String, ptoken: String, Document_numbasedoc: String){
        // Fonction test fonctionnelle
        let url = "https://demo-interne.ajaris.com/Demo/upImportDoc.do"
        
        let params = [
            "jsessionid": "E626D1160AC82031E6715474733937E3",
            "ptoken": "1Na7H2M6kDoUAU5EnoJK9lva34AhZHvCdd75iDHqn9CahMcVK1SRCRXclstGJQWIXG5mAo5Ivl4o1z9esut3lslW8XBDKpMrQu5fIzlAw2iHtI",
            "ajaupmo": "test",
            "ContributionComment": "TestIOS",
            "Document_numbasedoc": "6",
            "contribution": "true"
        ]
    
        AF.upload(multipartFormData: { MultipartFormData in
            MultipartFormData.append(imgData, withName: "filetoupload" , fileName: "image.jpeg" , mimeType: "image/jpeg")
            for(key,value) in params {
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, method: .post, headers: ["Cookie": "JSESSIONID=E626D1160AC82031E6715474733937E3"])
        .response { (response) in
            debugPrint(response)
        }.uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
    }
    

    override func didSelectPost() {
        print("Mes préférences")
        print(ProfilePreferences.getPreferences())
        print("In Did Post")
            if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem{
                print("Item \(item)")
                for ele in item.attachments!{
                    print("item.attachments!======&gt;&gt;&gt; \(ele as! NSItemProvider)")
                    let itemProvider = ele as! NSItemProvider
                    print(itemProvider)
                    if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
                        imageType = "public.jpeg"
                    }
                    if itemProvider.hasItemConformingToTypeIdentifier("public.png") {
                         imageType = "public.png"
                    }
                    print("imageType\(imageType)")
                    
                    if itemProvider.hasItemConformingToTypeIdentifier(imageType) {
                        print("True")
                        itemProvider.loadItem(forTypeIdentifier: imageType, options: nil, completionHandler: { (item, error) in
                            
                            var imgData: Data!
                            if let url = item as? URL{
                                imgData = try! Data(contentsOf: url)
                            }
                            
                            if let img = item as? UIImage{
                                imgData = img.pngData()
                            }
                            
                            self.upload(imgData: imgData, jsessionid: "45D732E9BCE79ABFEEC0EC960EE821BC", ptoken: "1Nacm_ncjUSAtQYYCpHAc2S5kWy0zk7koqYvOfEeWnCkuLFzftqXW3QLjQnQFbaknTNHkLqhgAY8j_mS9iwY3umAhQCsLwUCrnNSMzqtmsc6OQ", Document_numbasedoc: "6 - Generique")
                            
                            print("Item ===\(item)")
                            print("Image Data=====. \(imgData))")
                            let dict: [String : Any] = ["imgData" :  imgData, "name" : self.contentText]
                            let savedata =  UserDefaults.init(suiteName: "group.com.YourAppBundleID")
                            savedata?.set(dict, forKey: "img")
                            savedata?.synchronize()
                            print("ImageData \(String(describing: savedata?.value(forKey: "img")))")
                        })
                    }
                }
               
            }
            //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
