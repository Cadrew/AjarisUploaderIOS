//
//  ProfileView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct Profile: Identifiable {
    let id: Int
    let name:String
}

struct ProfileView: View {
    @State private var profiles = [
        Profile(id: 0, name: "Wangerooge"),
        Profile(id: 1, name: "Spiekeroog"),
        Profile(id: 2, name: "Langeoog")
    ]
    
    var body: some View {
        VStack {
            List {
                ForEach(profiles, id: \.id) { profile in
                    ProfileCards(category: profile.name, heading: "Drawing a Border with Rounded Corners", author: "Simon Ng")
                }.onDelete(perform: delete)
            }
        }
    }
    
    private func delete(with indexSet: IndexSet) {
        indexSet.forEach { profiles.remove(at: $0) }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
