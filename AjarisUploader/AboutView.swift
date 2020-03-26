//
//  AboutView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Ajaris UpLoader version 1.0.0")
                .font(.system(size: 20))
            
            HStack(spacing: 0) {
                Text("Ajaris est un produit ")
                    .font(.system(size: 20))
                
                Button("orkis.com") {
                    if let url = URL(string: "https://www.orkis.com") {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.system(size: 20))
                
                Text(".")
                .font(.system(size: 20))
            }
            
            Spacer()
            
            Button(action: rateApp) {
                Text("Noter l'application".uppercased())
                    .frame(minWidth: 0, maxWidth: 220, minHeight: 0, maxHeight: 50, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color(red: 51 / 255, green: 108 / 255, blue: 202 / 255))
                    .cornerRadius(5)
                    .disabled(true)
                    .font(.system(size: 15))
            }
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(
        Image("ajaris_background")
            .resizable())
    }
    
    private func rateApp() {
        // TODO: set appId
        let appId = "appId"
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + appId) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
