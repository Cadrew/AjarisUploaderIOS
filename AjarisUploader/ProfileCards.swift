//
//  ProfileCards.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct ProfileCards: View {
    var name: String
    var login: String
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    Text(login)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .topLeading)
            }
        .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        //.padding([.top, .horizontal])
    }
}

struct ProfileCards_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCards(name: "TEST", login: "TEST")
    }
}
