//
//  ContentView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/23/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView {
            ProfileView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Profils")
                    }
                }
                .tag(0)
            HistoryView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Historique")
                    }
                }
                .tag(1)
            AboutView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("À propos")
                    }
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
