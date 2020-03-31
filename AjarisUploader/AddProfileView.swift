//
//  AddProfileView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct AddProfileView: View {
    @State private var lastDocument: XMLProcessing = XMLProcessing(data: Data())!
    @State private var url: String = ""
    @State private var name: String = ""
    @State private var login: String = ""
    @State private var loginDisabled: Bool = true
    @State private var pwd: String = ""
    @State private var pwdDisabled: Bool = true
    @State private var base: String = ""
    @State private var importProfile: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("logo_uploader_alt")
                .resizable()
                .frame(width: 120, height: 33)
                .padding()
            
            Spacer()
            
            VStack {
                TextField("URL", text: $url, onEditingChanged: {_ in 
                    self.checkUrl()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Nom", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Pseudo", text: $login)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(self.loginDisabled)
                
                SecureField("Mot de passe", text: $pwd)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(self.pwdDisabled)
                
                Button(action: populateBasesAndImport) {
                    Text("OK".uppercased())
                        .frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: 50, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Color(red: 51 / 255, green: 108 / 255, blue: 202 / 255))
                        .cornerRadius(5)
                        .disabled(true)
                        .padding(.bottom, 10)
                }
            }
            
            Spacer()
            
            VStack {
                Button(action: addProfile) {
                    Text("Ajouter le profil".uppercased())
                        .frame(minWidth: 0, maxWidth: 320, minHeight: 0, maxHeight: 50, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Color(red: 51 / 255, green: 108 / 255, blue: 202 / 255))
                        .cornerRadius(5)
                        .disabled(true)
                        .padding(.bottom, 10)
                }
                
                Button(action: cancelProfile) {
                    Text("Annuler".uppercased())
                        .frame(minWidth: 0, maxWidth: 320, minHeight: 0, maxHeight: 50, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Color(red: 11 / 255, green: 138 / 255, blue: 202 / 255))
                        .cornerRadius(5)
                }
            }
            
            Spacer()
        }
        .background(
        Image("ajaris_background_alt")
            .resizable())
        .font(.system(size: 15))
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    private func checkUrl() {
        self.loginDisabled = true
        self.pwdDisabled = true
        RequestAPI.checkUrl(url: self.url) { (result) -> () in
            self.lastDocument = XMLProcessing(data: result)!
            if(self.lastDocument.getResults()![0]["error-code"] == "0") {
                self.loginDisabled = false
                self.pwdDisabled = false
            }
                
        }
    }
    
    private func addProfile() {
        // TODO
    }
    
    private func cancelProfile() {
        self.mode.wrappedValue.dismiss()
    }
    
    private func populateBasesAndImport() {
        // TODO
        RequestAPI.checkUrl(url: "https://demo-interne.ajaris.com/Demo") { (result) -> () in
            self.lastDocument = XMLProcessing(data: result)!
            if(self.lastDocument.getResults()![0]["error-code"] == "0") {
                self.loginDisabled = false
                self.pwdDisabled = false
            }
        }
    }
}

struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView()
    }
}
