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
    var sc_uploadURL = ""
    var item = SLComposeSheetConfigurationItem()!
    var profiles = ProfilePreferences.getPreferences()
    var indexProfile = 0
    var countUploads = 0
    var lastDocument: XMLProcessing = XMLProcessing(data: Data())!
    let errorLogin = UIAlertController(title: "Erreur", message: "Identifiants incorrects", preferredStyle: .alert)
    let errorUpload = UIAlertController(title: "Erreur", message: "Erreur d'envoi", preferredStyle: .alert)
    let errorFileSize = UIAlertController(title: "Erreur", message: "Fichier trop volumineux", preferredStyle: .alert)
    
    override func configurationItems() -> [Any]! {
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")
                
            @unknown default:
                fatalError()
        }})
        self.errorLogin.addAction(alertAction)
        self.errorUpload.addAction(alertAction)
        self.errorFileSize.addAction(alertAction)
        
        self.item.title = "Profil"
        self.item.value = self.getLastChosenProfileName()
        self.item.tapHandler = self.show
        return [self.item]
    }

    func show() {
        self.indexProfile += 1
        self.item.value = self.profiles[self.indexProfile%profiles.count].getName()
        self.sc_uploadURL = self.profiles[self.indexProfile%profiles.count].getUrl()
    }
    
    func getLastChosenProfileName() -> String {
        let upload = UploadPreferences.getPreferences()[0].getUploads()[0]
        for i in 0...self.profiles.count - 1 {
            if(upload.getProfile().equal(profile: self.profiles[i])) {
                self.indexProfile = i
                break
            }
        }
        self.sc_uploadURL = self.profiles[self.indexProfile].getUrl()
        return self.profiles[self.indexProfile].getName()
    }
        
    func upload(imgData: Data, jsessionid: String, ptoken: String, ContributionComment: String, Document_numbasedoc: String, numberUploads: Int) {
        //TODO: Get file name
        let url = self.sc_uploadURL
        let progressView = UIProgressView.init(progressViewStyle: UIProgressView.Style.default)
        
        let params = [
            "jsessionid": jsessionid,
            "ptoken": ptoken,
            "ajaupmo": "ajaupmo",
            "ContributionComment": ContributionComment,
            "Document_numbasedoc": Document_numbasedoc,
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
            var hasError = false
            let result = XMLProcessing(data: response.data ?? Data())!
            
            //TODO: Handle "code" in upload response and not "error-code"
            /*if(result.getResults()![0]["error-code"] != "0") {
                print("Erreur d'envoi")
                self.present(self.errorUpload, animated: true, completion: nil)
                hasError = true
            }*/
            
            if(!hasError) {
                //TODO: Populate the contribution with this upload if it succeeded
            }
            
            self.countUploads += 1
            if(self.countUploads == numberUploads) {
                self.closeSharing()
            }
        }.uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            //TODO: Display progress bar in notifications (should we create another extension app??)
            self.view.addSubview(progressView)
            progressView.setProgress(Float(progress.fractionCompleted), animated: true)
        }
    }
    
    override func didSelectPost() {
        print("In Did Post")
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem {
            print("Item \(item)")
            RequestAPI.login(url: self.profiles[self.indexProfile].getUrl(), login: self.profiles[self.indexProfile].getLogin(), pwd: self.profiles[self.indexProfile].getPwd()) { (result) -> () in
                if(result.isEmpty) {
                    print("Identifiants incorrects")
                    self.present(self.errorLogin, animated: true, completion: nil)
                    return
                }
                self.lastDocument = XMLProcessing(data: result)!
                self.formatUploads(item: item)
            }
        }
    }
    
    func formatUploads(item: NSExtensionItem) {
        let numberUploads = item.attachments!.count
        for ele in item.attachments! {
            print("item.attachments!======&gt;&gt;&gt; \(ele)")
            let itemProvider = ele
            if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
                self.imageType = "public.jpeg"
            }
            if itemProvider.hasItemConformingToTypeIdentifier("public.png") {
                self.imageType = "public.png"
            }
                
            if itemProvider.hasItemConformingToTypeIdentifier(self.imageType) {
                itemProvider.loadItem(forTypeIdentifier: self.imageType, options: nil, completionHandler: { (item, error) in
                    var imgData: Data!
                    if let url = item as? URL{
                        imgData = try! Data(contentsOf: url)
                    }
                        
                    if let img = item as? UIImage{
                        imgData = img.pngData()
                    }
                    
                    if imgData.count >= self.lastDocument.getUploadMaxFileSize() {
                        print("Fichier trop volumineux")
                        //TODO: Display error
                    } else {
                        self.upload(imgData: imgData, jsessionid: self.lastDocument.getResults()![0]["sessionid"]!, ptoken: self.lastDocument.getResults()![0]["ptoken"]!, ContributionComment: self.contentText!, Document_numbasedoc: String(self.profiles[self.indexProfile].getBase().getId()), numberUploads: numberUploads)
                    }
                })
            }
        }
    }
    
    func closeSharing() {
        RequestAPI.logout(url: self.profiles[self.indexProfile].getUrl(), sessionid: self.lastDocument.getResults()![0]["sessionid"]!) { () -> () in
            //TODO: Save contribution in UserDefault
        }
    }
}

