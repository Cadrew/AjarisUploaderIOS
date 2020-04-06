//
//  ProfileCards.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct ProfileCards: View {
    var profile: Profile
    @State private var showDialog = false
    
    var body: some View {
        VStack {
            Button(action: openProfileDialog) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(profile.getName())
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                        Text(profile.getLogin())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(100)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .topLeading)
                    
                    Image("icon_ajaris")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }.sheet(isPresented: $showDialog) {
                ProfileDialog(profile: self.profile, showDialog: self.$showDialog)
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
    }
    
    private func openProfileDialog() {
        self.showDialog.toggle()
    }
}

struct ProfileCards_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCards(profile: Profile())
    }
}
