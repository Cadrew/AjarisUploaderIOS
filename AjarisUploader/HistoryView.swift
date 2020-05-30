//
//  HistoryView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @State private var contributions: [Contribution] = UploadPreferences.getPreferences()
    
    var body: some View {
        VStack{
            Form {
                ForEach(contributions, id: \.id) { contribution in
                    ContributionCards(contribution: contribution)
                        .background(Color.gray.opacity(0.15))
                }
            }
            .background(Color.white.opacity(0))
                
            Spacer()
        }
        .background(
        Image("ajaris_background")
            .resizable())
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
