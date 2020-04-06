//
//  ContributionCards.swift
//  AjarisUploader
//
//  Created by user163559 on 4/5/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct ContributionCards: View {
    var contribution: Contribution
    @State private var showDialog = false
    
    var body: some View {
        VStack {
            Button(action: openHistoryDialog) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(String(contribution.getId()))
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    .layoutPriority(100)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .topLeading)
                    
                    Image("icon_ajaris")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }.sheet(isPresented: $showDialog) {
                HistoryDialog(contribution: self.contribution, showDialog: self.$showDialog)
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
    }
    
    private func openHistoryDialog() {
        self.showDialog.toggle()
    }
}

struct ContributionCards_Previews: PreviewProvider {
    static var previews: some View {
        ContributionCards(contribution: Contribution())
    }
}
