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
    let UPIMPORTDOC = "/upImportDoc.do"
    var imageType = ""
    var sc_uploadURL = ""
    var item = SLComposeSheetConfigurationItem()!
    var profiles = ProfilePreferences.getPreferences()
    var indexProfile = 0
    var countUploads = 0
    var lastDocument: XMLProcessing = XMLProcessing(data: Data())!
    let errorDialog = UIAlertController(title: "Erreur", message: "Identifiants incorrects", preferredStyle: .alert)
    let contribution = Contribution()
    
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
        self.errorDialog.addAction(alertAction)
        
        self.item.title = "Profil"
        self.item.value = self.getLastChosenProfileName()
        self.item.tapHandler = self.show
        return [self.item]
    }

    func show() {
        self.indexProfile += 1
        self.item.value = self.profiles[self.indexProfile%self.profiles.count].getName()
        self.sc_uploadURL = self.profiles[self.indexProfile%self.profiles.count].getUrl()
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
        //TODO: Get file name and URI
        let fileName = "image.jpeg"
        let url = self.sc_uploadURL + UPIMPORTDOC
        print("URL: \(url)")
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
            MultipartFormData.append(imgData, withName: "filetoupload" , fileName: fileName , mimeType: "image/jpeg")
            for(key,value) in params {
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, method: .post, headers: ["Cookie": "JSESSIONID="+jsessionid])
        .response { (response) in
            var hasError = false
            let result = XMLImportDoc(data: response.data ?? Data())!
            
            if(result.getResults() == nil || result.getResults()![0]["code"] != "0") {
                self.errorDialog.message = "Erreur d'envoi"
                self.present(self.errorDialog, animated: true, completion: nil)
                hasError = true
            }
            
            if(!hasError) {
                self.contribution.setId(id: Int(result.getResults()![0]["contribution-id"]!) ?? 0)
                let upload = Upload(id: self.countUploads, file: fileName, comment: ContributionComment, profile: self.profiles[self.indexProfile%self.profiles.count], date: Date())
                self.contribution.addUpload(upload: upload)
            }
            
            self.countUploads += 1
            if(self.countUploads == numberUploads) {
                self.closeSharing()
            }
        }.uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            //TODO: Display progress bar in notifications (should we create another extension app??)(warning: Maybe not iOS friendly)
            self.view.addSubview(progressView)
            progressView.setProgress(Float(progress.fractionCompleted), animated: true)
        }
    }
    
    override func didSelectPost() {
        print("In Did Post")
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem {
            print("Item \(item)")
            RequestAPI.login(url: self.profiles[self.indexProfile%self.profiles.count].getUrl(), login: self.profiles[self.indexProfile%self.profiles.count].getLogin(), pwd: self.profiles[self.indexProfile%self.profiles.count].getPwd()) { (result) -> () in
                if(result.isEmpty) {
                    self.errorDialog.message = "Identifiants incorrects"
                    self.present(self.errorDialog, animated: true, completion: nil)
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
                        //TODO: Display error (now or then?)
                    } else {
                        self.upload(imgData: imgData, jsessionid: self.lastDocument.getResults()![0]["sessionid"]!, ptoken: self.lastDocument.getResults()![0]["ptoken"]!, ContributionComment: self.contentText!, Document_numbasedoc: String(self.profiles[self.indexProfile].getBase().getId()), numberUploads: numberUploads)
                    }
                })
            }
        }
        //TODO: Run app in background or display a progression in a dialog (I'm not sure we can run app in background, it's not iOS friendly for this use case)
    }
    
    func closeSharing() {
        RequestAPI.logout(url: self.profiles[self.indexProfile].getUrl(), sessionid: self.lastDocument.getResults()![0]["sessionid"]!) { () -> () in
            if(!self.contribution.isEmpty()) {
                print(self.contribution)
                UploadPreferences.addPreferences(contribution: self.contribution)
            }
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
}

