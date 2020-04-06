//
//  HistoryDialog.swift
//  AjarisUploader
//
//  Created by user163559 on 4/6/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct HistoryDialog: View {
    @State var contribution: Contribution
    @Binding var showDialog: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Contribution : ")
                
                Text(String(contribution.getId()))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 70, alignment: .center)
            .foregroundColor(Color.white)
            .font(.system(size: 25))
            .background(Color(red: 11 / 255, green: 138 / 255, blue: 202 / 255))
            
            Form {
                ForEach(contribution.getUploads(), id: \.id) { upload in
                    UploadCards(upload: upload)
                        .background(Color.gray.opacity(0.15))
                }
            }
            
            Spacer()
            
            Button("Retour") {
                self.showDialog.toggle()
            }
            .padding(10)
        }
    }
}

struct HistoryDialog_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDialog(contribution: Contribution(), showDialog: .constant(true))
    }
}
