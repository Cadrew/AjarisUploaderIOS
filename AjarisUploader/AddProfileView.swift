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
    @State private var previousUrl: String = ""
    @State private var name: String = ""
    @State private var login: String = ""
    @State private var loginDisabled: Bool = true
    @State private var pwd: String = ""
    @State private var previousPwd: String = ""
    @State private var pwdIsFocused: Bool = false
    @State private var pwdDisabled: Bool = true
    @State private var baseIndex: Int = 0
    @State private var bases: [String] = []
    @State private var basesNum: [Int] = []
    @State private var importIndex: Int = 0
    @State private var importProfile: [String] = []
    @State private var addDisabled: Bool = true
    @State private var showBasesAndImport: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var alertDismiss: String = ""
    @State private var showAlert: Bool = false
    @State private var addText: String = "Ajouter le profil"
    @State private var isEdit : Bool = false
    @State private var profileId : Int = -1
    
    @Binding var profiles: [Profile]
    
    var body: some View {
        VStack {
            Button(action: cancelProfile) {
                HStack(spacing: 0) {
                    Image("back_arrow")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 13, height: 22)
                    
                    Text("  Retour")
                        .foregroundColor(Color.white)
                    
                    Spacer()
                }
                .font(.system(size: 20))
            }
            .padding(10)
            
            Spacer()
            
            Image("logo_uploader_alt")
                .resizable()
                .frame(width: 120, height: 33)
                .padding()
            
            Spacer()
            
            VStack {
                TextField("URL", text: $url, onEditingChanged: {_ in
                    if(self.previousUrl != self.url) {
                        self.checkUrl()
                    }
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
                
                if !self.showBasesAndImport {
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
            }
            
            if self.showBasesAndImport {
                VStack {
                    Picker(selection: $baseIndex, label: Text("Bases").foregroundColor(Color.white)) {
                        ForEach(0 ..< bases.count) {
                            Text(self.bases[$0]).tag($0)
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 620, minHeight: 0, maxHeight: 30)
                    .padding(.bottom, 100)
                    .padding(.top, 10)
                    
                    Picker(selection: $importIndex, label: Text("Profils d'import").foregroundColor(Color.white)) {
                        ForEach(0 ..< importProfile.count) {
                            Text(self.importProfile[$0]).tag($0)
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 620, minHeight: 0, maxHeight: 30)
                }
                .colorMultiply(.white)
            }
                        
            Spacer()
            
            VStack {
                Button(action: addProfile) {
                    Text(self.addText.uppercased())
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text(alertDismiss)))
        }
    }
    
    init(profile: Profile,_ profiles: Binding<[Profile]>) {
        UITableView.appearance().backgroundColor = .clear
        self._profiles = profiles
        self._addText = State(initialValue: "Éditer le profil")
        self._url = State(initialValue: profile.getUrl())
        self._previousUrl = State(initialValue: profile.getUrl())
        self._name = State(initialValue: profile.getName())
        self._login = State(initialValue: profile.getLogin())
        self._profileId = State(initialValue: profile.getId())
        self._isEdit = State(initialValue: true)
        self._pwdDisabled = State(initialValue: false)
        self._loginDisabled = State(initialValue: false)
    }
    
    init(_ profiles: Binding<[Profile]>) {
        UITableView.appearance().backgroundColor = .clear
        self._profiles = profiles
    }

    init() {
        UITableView.appearance().backgroundColor = .clear
        self._profiles = Binding.constant([Profile()])
    }
    
    private func checkUrl() {
        self.loginDisabled = true
        self.pwdDisabled = true
        if(self.url == "") {
            return
        }
        RequestAPI.checkUrl(url: self.url) { (result) -> () in
            self.previousUrl = self.url
            if(result.isEmpty) {
                self.showAlertMessage(title: "URL incorrecte", message: "Veuillez saisir une autre URL.", dismiss: "OK")
                return
            }
            self.lastDocument = XMLProcessing(data: result)!
            if(self.lastDocument.getResults()![0]["error-code"] == "0") {
                self.loginDisabled = false
                self.pwdDisabled = false
            } else {
                self.showAlertMessage(title: "URL incorrecte", message: "Veuillez saisir une autre URL.", dismiss: "OK")
                self.login = ""
                self.pwd = ""
                self.loginDisabled = true
                self.pwdDisabled = true
                self.showBasesAndImport = false
            }
        }
    }
    
    private func addProfile() {
        if(self.lastDocument.getResults() != nil && self.lastDocument.getResults()![0]["sessionid"] != nil) {
            RequestAPI.login(url: self.url, login: self.login, pwd: self.pwd) { (result) -> () in
                if(result.isEmpty) {
                    return
                }
                self.lastDocument = XMLProcessing(data: result)!
                if(self.lastDocument.getBases() != self.bases || self.lastDocument.getImports() != self.importProfile ||
                    self.bases[self.baseIndex] == XMLProcessing.DefaultField ||
                    self.importProfile[self.importIndex] == XMLProcessing.DefaultField) {
                    self.bases = self.lastDocument.getBases()
                    self.basesNum = self.lastDocument.getBasesNum()
                    self.importProfile = self.lastDocument.getImports()
                    self.showAlertMessage(title: "Paramètres invalides", message: "Veuillez renseigner à nouveau votre base ainsi que votre profil d'import.", dismiss: "OK")
                    return
                }
                RequestAPI.logout(url: self.url, sessionid: self.lastDocument.getResults()![0]["sessionid"]!) { () -> () in
                    let profiles = ProfilePreferences.getPreferences()
                    let id = self.profileId == -1 ? self.newId(profiles: profiles) : self.profileId
                    let profile = Profile(id: id, name: self.name, login: self.login, pwd: self.pwd, url: self.url, base: Base(id: self.basesNum[self.baseIndex], label: self.bases[self.baseIndex]), importProfile: self.importProfile[self.importIndex])
                    if(self.isEdit) {
                        for i in 0...self.profiles.count-1 {
                            if(self.profiles[i].getId() == profile.getId()) {
                                self.profiles[i] = profile
                            }
                        }
                        ProfilePreferences.savePreferences(profiles: self.profiles)
                    } else {
                        self.profiles.append(profile)
                        ProfilePreferences.addPreferences(profile: profile)
                    }
                    DispatchQueue.main.async {
                        self.mode.wrappedValue.dismiss()
                    }
                    
                }
            }
        } else {
            self.mode.wrappedValue.dismiss()
        }
    }
    
    private func cancelProfile() {
        if(self.lastDocument.getResults() != nil && self.lastDocument.getResults()![0]["sessionid"] != nil) {
            RequestAPI.logout(url: self.url, sessionid: self.lastDocument.getResults()![0]["sessionid"]!) { () -> () in
                DispatchQueue.main.async {
                    self.mode.wrappedValue.dismiss()
                }                               
            }
        } else {
            self.mode.wrappedValue.dismiss()
        }
    }
    
    private func populateBasesAndImport() {
        self.addDisabled = true
        if(self.login == "" || self.pwd == "" ) {
            return
        }
        RequestAPI.login(url: self.url, login: self.login, pwd: self.pwd) { (result) -> () in
            if(result.isEmpty) {
                self.showAlertMessage(title: "Identifiants incorrects", message: "Veuillez renseigner de nouveaux identifiants.", dismiss: "OK")
                return
            }
            self.lastDocument = XMLProcessing(data: result)!
            if(self.lastDocument.getResults()![0]["error-code"] == "0") {
                self.bases = self.lastDocument.getBases()
                self.basesNum = self.lastDocument.getBasesNum()
                self.importProfile = self.lastDocument.getImports()
                self.addDisabled = false
                self.loginDisabled = true
                self.pwdDisabled = true
                self.showBasesAndImport = true
            } else {
                self.showAlertMessage(title: "Identifiants incorrects", message: "Veuillez renseigner de nouveaux identifiants.", dismiss: "OK")
                self.addDisabled = true
                self.loginDisabled = false
                self.pwdDisabled = false
                self.showBasesAndImport = false
            }
        }
    }
    
    private func showAlertMessage(title: String, message: String, dismiss: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.alertDismiss = dismiss
        self.showAlert = true
    }
    
    private func newId(profiles: [Profile]) -> Int {
        var id = 0
        for profile in profiles {
            if(profile.getId() > id) {
                id = profile.getId()
            }
        }
        return id + 1
    }
}

struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView()
    }
}
