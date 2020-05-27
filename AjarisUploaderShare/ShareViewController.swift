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
        return [item]
    }

    func show() {
        print("TEST")
    }
        
    func upload(imgData: Data, jsessionid: String, ptoken: String, Document_numbasedoc: String){
        // Fonction test fonctionnelle
        let url = "https://demo-interne.ajaris.com/Demo/upImportDoc.do"
        
        let params = [
            "jsessionid": jsessionid,
            "ptoken": ptoken,
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
        }, to: url, method: .post, headers: ["Cookie": "JSESSIONID="+jsessionid])
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
                            
                            self.upload(imgData: imgData, jsessionid: "952E3A3013242D61EDE7FAF1E30CF46E", ptoken: "1Na93x_cQGa0FnyLluBYIUW_Qx6kzOtqFGQa11LKvBM09wCyOwXUXr7ufZ1AlXFQdyXWe5d_Dn6vB-svyOvF-mQGMpIumH5GodwbyrrE2pASP0", Document_numbasedoc: "6 - Generique")
                            
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

