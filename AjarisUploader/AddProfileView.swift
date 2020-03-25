//
//  AddProfileView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct AddProfileView: View {
    @State private var url: String = ""
    @State private var name: String = ""
    @State private var login: String = ""
    @State private var pwd: String = ""
    @State private var base: String = ""
    @State private var importProfile: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("logo_uploader_alt")
                .resizable()
                .frame(width: 120, height: 33)
                .padding()
            
            Spacer()
            
            VStack {
                TextField("URL", text: $url)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Nom", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Pseudo", text: $login)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Mot de passe", text: $pwd)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer()
            
            VStack {
                Button(action: addProfile) {
                    Text("Ajouter le profil".uppercased())
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                .foregroundColor(Color.white)
                .background(Color(red: 51 / 255, green: 108 / 255, blue: 202 / 255))
                .cornerRadius(5)
                .disabled(true)
                
                Button(action: cancelProfile) {
                    Text("Annuler".uppercased())
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                .foregroundColor(Color.white)
                .background(Color(red: 11 / 255, green: 138 / 255, blue: 202 / 255))
                .cornerRadius(5)
            }
            
            Spacer()
        }
        .background(
        Image("ajaris_background_alt")
            .resizable())
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    private func addProfile() {
        // TODO
    }
    
    private func cancelProfile() {
        // TODO
    }
}

struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView()
    }
}
