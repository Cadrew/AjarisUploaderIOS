//
//  UploadCards.swift
//  AjarisUploader
//
//  Created by user163559 on 4/6/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct UploadCards: View {
    var upload: Upload
    
    var body: some View {
        VStack {
            HStack {
                Image(upload.getFile())
                    .resizable()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(upload.getFileName())
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(upload.getComment())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 60, alignment: .topLeading)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(upload.getDisplayDate())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(upload.getProfile().getName())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
            }
        .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
    }
}

struct UploadCards_Previews: PreviewProvider {
    static var previews: some View {
        UploadCards(upload: Upload(id: 0, file: "test.png", comment: "test comment", profile: Profile(id: 0, name: "Mistale", login: "mistale", pwd: "software", url: "", base: Base(), importProfile: ""), date: Date()))
    }
}
