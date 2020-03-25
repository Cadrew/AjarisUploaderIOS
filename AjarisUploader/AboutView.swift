//
//  AboutView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Ajaris UpLoader version 1.0.0")
            
            Text("Ajaris est un produit orkis.com")
            
            Spacer()
            
            Button(action: rateApp) {
                Text("Noter l'application".uppercased())
                    .frame(minWidth: 0, maxWidth: 220, minHeight: 0, maxHeight: 50, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color(red: 51 / 255, green: 108 / 255, blue: 202 / 255))
                    .cornerRadius(5)
                    .disabled(true)
            }
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(
        Image("ajaris_background")
            .resizable())
    }
    
    private func rateApp() {
        // TODO
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
