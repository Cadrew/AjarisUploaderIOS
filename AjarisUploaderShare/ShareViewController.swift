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
    let progressView = UIProgressView.init(progressViewStyle: UIProgressView.Style.default)
    var progressValue : Double = 0
    let indicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
    var profiles = ProfilePreferences.getPreferences()
    var indexProfile = 0
    var countUploads = 0
    var lastDocument: XMLProcessing = XMLProcessing(data: Data())!
    let errorDialog = UIAlertController(title: "Erreur", message: "", preferredStyle: .alert)
    var contribution = Contribution()
    var allContributions : [Contribution] = []
    struct FileToUpload {
        var imgData: Data
        var itemURI: NSURL
        var jsessionid: String
        var ptoken: String
        var ContributionComment: String
        var Document_numbasedoc: String
        var numberUploads: Int
    }
    
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
        self.progressView.center = self.view.center
        self.view.addSubview(self.progressView)
        self.indicator.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)
        self.indicator.center = CGPoint(x: self.view.frame.size.width  / 2, y: self.view.frame.size.height / 2 - 20)
        self.view.addSubview(self.indicator)
        
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
        self.allContributions = UploadPreferences.getPreferences()
        if(self.profiles.isEmpty) {
            self.errorDialog.message = "Vous devez ajouter un profil avant d'envoyer des fichiers."
            self.present(self.errorDialog, animated: true, completion: nil)
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
            return ""
        }
        if(self.allContributions.isEmpty) {
            self.sc_uploadURL = self.profiles[self.indexProfile].getUrl()
            return self.profiles[self.indexProfile].getName()
        }
        let upload =  self.allContributions[0].getUploads()[0]
        for i in 0...self.profiles.count - 1 {
            if(upload.getProfile().equal(profile: self.profiles[i])) {
                self.indexProfile = i
                break
            }
        }
        self.sc_uploadURL = self.profiles[self.indexProfile].getUrl()
        return self.profiles[self.indexProfile].getName()
    }
        
    func upload(imgData: Data, itemURI: NSURL, jsessionid: String, ptoken: String, ContributionComment: String, Document_numbasedoc: String, numberUploads: Int) {
        let fileURI = itemURI.absoluteString!
        let fileName =  itemURI.lastPathComponent!
        let url = self.sc_uploadURL + UPIMPORTDOC
        print("URL: \(url)")
        
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
                let upload = Upload(id: Int(Date().timeIntervalSince1970) + self.countUploads * 10000, file: fileURI, fileData: imgData, comment: ContributionComment, profile: self.profiles[self.indexProfile%self.profiles.count], date: Date())
                self.contribution.addUpload(upload: upload)
            }
            
            self.countUploads += 1
            if(self.countUploads == numberUploads) {
                self.closeSharing()
            }
        }.uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            self.progressValue += progress.fractionCompleted
            self.updateProgressBar(numberUploads: numberUploads)
            self.indicator.bringSubviewToFront(self.view)
            if !self.indicator.isAnimating {
                self.indicator.startAnimating()
            }
        }
    }
    
    func updateProgressBar(numberUploads: Int) {
        self.progressView.setProgress(Float(self.progressValue / Double(numberUploads)), animated: true)
    }
    
    override func didSelectPost() {
        print("In Did Post")
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem {
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
        var filesToUpload = [ Int: FileToUpload ]()
        var count = 0
        for ele in item.attachments! {
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
                    let itemURI = item as! NSURL
                    
                    if let url = item as? URL{
                        imgData = try! Data(contentsOf: url)
                    }
                        
                    if let img = item as? UIImage{
                        imgData = img.pngData()
                    }
                    
                    print("URI: \(itemURI.relativePath ?? "")")
                    if imgData.count >= self.lastDocument.getUploadMaxFileSize() {
                        print("Fichier trop volumineux")
                        self.errorDialog.message = "Le fichier \(itemURI.lastPathComponent!) est trop volumineux (> \(String(self.lastDocument.getUploadMaxFileSize()/(1000*1000))) Mo)."
                        self.present(self.errorDialog, animated: true, completion: nil)
                        RequestAPI.logout(url: self.profiles[self.indexProfile].getUrl(), sessionid: self.lastDocument.getResults()![0]["sessionid"]!) { () -> () in
                            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                        }
                    } else {
                        filesToUpload[count] = FileToUpload(imgData: imgData, itemURI: itemURI, jsessionid: self.lastDocument.getResults()![0]["sessionid"]!, ptoken: self.lastDocument.getResults()![0]["ptoken"]!, ContributionComment: self.contentText!, Document_numbasedoc: String(self.profiles[self.indexProfile].getBase().getId()), numberUploads: numberUploads)
                        count += 1
                        if(count == numberUploads) {
                            for i in 0...filesToUpload.count - 1 {
                                self.upload(imgData: filesToUpload[i]!.imgData, itemURI: filesToUpload[i]!.itemURI, jsessionid: filesToUpload[i]!.jsessionid, ptoken: filesToUpload[i]!.ptoken, ContributionComment: filesToUpload[i]!.ContributionComment, Document_numbasedoc: filesToUpload[i]!.Document_numbasedoc, numberUploads: filesToUpload[i]!.numberUploads)
                            }
                        }
                    }
                })
            }
        }
    }
    
    func closeSharing() {
        RequestAPI.logout(url: self.profiles[self.indexProfile].getUrl(), sessionid: self.lastDocument.getResults()![0]["sessionid"]!) { () -> () in
            if(!self.contribution.isEmpty()) {
                let oldContribution = Contribution.getContributionById(contributions: self.allContributions, id: self.contribution.getId())
                if(oldContribution.isEmpty()) {
                    UploadPreferences.addPreferences(contribution: self.contribution)
                } else {
                    for upload in self.contribution.getUploads() {
                        oldContribution.addUpload(upload: upload)
                    }
                    UploadPreferences.addPreferences(contribution: oldContribution)
                }
            }
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
}

