//
//  ProfileDialog.swift
//  AjarisUploader
//
//  Created by user163559 on 4/6/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct ProfileDialog: View {
    @State var profile: Profile
    @Binding var showDialog: Bool
    
    var body: some View {
        VStack {
            Text(profile.getName())
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 70, alignment: .center)
                .foregroundColor(Color.white)
                .font(.system(size: 25))
                .background(Color(red: 11 / 255, green: 138 / 255, blue: 202 / 255))
                .padding(.bottom, 30)
            
            VStack {                    
                HStack(spacing: 0) {
                    Text("URL : ")
                    
                    Spacer()
                        
                    Text(profile.getUrl())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
                
                HStack(spacing: 0) {
                    Text("Pseudo : ")
                    
                    Spacer()
                    
                    Text(profile.getLogin())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
                
                HStack(spacing: 0) {
                    Text("Base : ")
                    
                    Spacer()
                    
                    Text(profile.getBase().getLabel())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
                
                HStack(spacing: 0) {
                    Text("Profil d'import : ")
                    
                    Spacer()
                    
                    Text(profile.getImportProfile())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
            }
            .padding()
            
            Spacer()
            
            Button("Retour") {
                self.showDialog.toggle()
            }
            .padding(10)
        }
    }
}

struct ProfileDialog_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDialog(profile: Profile(), showDialog: .constant(true))
    }
}
