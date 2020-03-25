//
//  ProfileView.swift
//  AjarisUploader
//
//  Created by user163559 on 3/24/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @State private var profiles = ProfilePreferences.getPreferences()
    @State private var addProfileActive: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(profiles, id: \.id) { profile in
                    ProfileCards(name: profile.getName(), login: profile.getLogin())
                }
                .onDelete(perform: delete)
            }
            
            Button(action: {
                self.addProfileActive = true
            }) {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color(red: 11 / 255, green: 138 / 255, blue: 202 / 255))
                    .clipShape(Circle())
            }
            .padding()
            
            NavigationLink(destination: AddProfileView(), isActive: $addProfileActive) {
                Text("")
            }
        }
    }
    
    init() {
        /** For tests purpose **/
        // TODO: Remove
        ProfilePreferences.removeAllPreferences()
        ProfilePreferences.addPreferences(profile: Profile(id: 0, name: "Adrien CANINO", login: "mistale", pwd: "", url: "", base: Base(), importProfile: ""))
        ProfilePreferences.addPreferences(profile: Profile(id: 1, name: "Alexandre DO-O ALMEIDA", login: "mistale", pwd: "", url: "", base: Base(), importProfile: ""))
        self.profiles = ProfilePreferences.getPreferences()
        /******************/
    }
    
    private func delete(with indexSet: IndexSet) {
        indexSet.forEach {
            ProfilePreferences.removePreference(profile: getProfile(from: profiles, at: $0))
            profiles.remove(at: $0)
        }
    }
    
    private func getProfile(from: [Profile], at: Int) -> Profile {
        for profile in from {
            if(profile.getId() == at) {
                return profile
            }
        }
        return Profile()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
