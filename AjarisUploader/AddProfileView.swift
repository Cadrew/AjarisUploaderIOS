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
    @State private var previousPwd: String = ""
    @State private var pwdIsFocused: Bool = false
    @State private var pwdDisabled: Bool = true
    @State private var base: String = ""
    @State private var importProfile: String = ""
    @State private var addDisabled: Bool = true
    @State private var showBasesAndImport: Bool = false
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
                .simultaneousGesture(TapGesture().onEnded {
                    if(self.pwdIsFocused && self.pwd != self.previousPwd) {
                        self.previousPwd = self.pwd
                        self.populateBasesAndImport()
                    }
                    self.pwdIsFocused = false
                })
                
                TextField("Nom", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        if(self.pwdIsFocused && self.pwd != self.previousPwd) {
                            self.previousPwd = self.pwd
                            self.populateBasesAndImport()
                        }
                        self.pwdIsFocused = false
                    })
                
                TextField("Pseudo", text: $login, onEditingChanged: {_ in
                    self.populateBasesAndImport()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .simultaneousGesture(TapGesture().onEnded {
                    if(self.pwdIsFocused && self.pwd != self.previousPwd) {
                        self.previousPwd = self.pwd
                        self.populateBasesAndImport()
                    }
                    self.pwdIsFocused = false
                })
                .disabled(self.loginDisabled)
                
                SecureField("Mot de passe", text: $pwd)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        self.pwdIsFocused = true
                    })
                    .disabled(self.pwdDisabled)
                
                Button(action: populateBasesAndImport) {
                    Text("Continuer".uppercased())
                        .frame(minWidth: 0, maxWidth: 150, minHeight: 0, maxHeight: 50, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Color(red: 51 / 255, green: 108 / 255, blue: 202 / 255))
                        .cornerRadius(5)
                        .disabled(true)
                        .padding(.bottom, 10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    self.pwdIsFocused = false
                })
            }
            
            if self.showBasesAndImport {
                VStack {
                    Text("Bonjour")
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
                        .disabled(self.addDisabled)
                        .padding(.bottom, 10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    self.pwdIsFocused = false
                })
                
                Button(action: cancelProfile) {
                    Text("Annuler".uppercased())
                        .frame(minWidth: 0, maxWidth: 320, minHeight: 0, maxHeight: 50, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Color(red: 11 / 255, green: 138 / 255, blue: 202 / 255))
                        .cornerRadius(5)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    self.pwdIsFocused = false
                })
            }
            
            Spacer()
        }
        .background(
        Image("ajaris_background_alt")
            .resizable())
        .font(.system(size: 15))
        .alert(isPresented: $pwdDisabled) {
            Alert(title: Text("Hello SwiftUI!"), message: Text("This is some detail message"), dismissButton: .default(Text("OK")))
        }
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    private func checkUrl() {
        self.loginDisabled = true
        self.pwdDisabled = true
        if(self.url == "") {
            return
        }
        RequestAPI.checkUrl(url: self.url) { (result) -> () in
            if(result.isEmpty) {
                Alert(title: Text("URL incorrecte"), message: Text("Veuillez saisir une autre URL."), dismissButton: .default(Text("OK")))
                return
            }
            self.lastDocument = XMLProcessing(data: result)!
            if(self.lastDocument.getResults()![0]["error-code"] == "0") {
                self.loginDisabled = false
                self.pwdDisabled = false
            } else {
                Alert(title: Text("URL incorrecte"), message: Text("Veuillez saisir une autre URL."), dismissButton: .default(Text("OK")))
                self.login = ""
                self.pwd = ""
                self.loginDisabled = true
                self.pwdDisabled = true
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
        self.addDisabled = true
        if(self.login == "" || self.pwd == "" ) {
            return
        }
        RequestAPI.login(url: self.url, login: self.login, pwd: self.pwd) { (result) -> () in
            if(result.isEmpty) {
                Alert(title: Text("Identifiants incorrects"), message: Text("Pseudo ou mot de passe incorrect."), dismissButton: .default(Text("OK")))
                return
            }
            self.lastDocument = XMLProcessing(data: result)!
            if(self.lastDocument.getResults()![0]["error-code"] == "0") {
                // TODO: populate
                self.addDisabled = false
                self.showBasesAndImport = true
            } else {
                // TODO: display message 'Identifiants incorrects'
                Alert(title: Text("Identifiants incorrects"), message: Text("Pseudo ou mot de passe incorrect."), dismissButton: .default(Text("OK")))
                self.addDisabled = true
                self.showBasesAndImport = false
            }
        }
    }
}

struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView()
    }
}
