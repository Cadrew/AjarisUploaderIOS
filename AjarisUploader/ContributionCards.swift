//
//  ContributionCards.swift
//  AjarisUploader
//
//  Created by user163559 on 4/5/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct ContributionCards: View {
    var name: String
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                .layoutPriority(100)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .topLeading)
                
                Image("icon_ajaris")
                    .resizable()
                    .frame(width: 30, height: 30)
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

struct ContributionCards_Previews: PreviewProvider {
    static var previews: some View {
        ContributionCards(name: "")
    }
}
