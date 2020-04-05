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
        NavigationView {
            VStack {
                Form {
                    ForEach(profiles, id: \.id) { profile in
                        ProfileCards(name: profile.getName(), login: profile.getLogin())
                            .background(Color.gray.opacity(0.15))
                    }
                    .onDelete(perform: delete)
                }
                .background(Color.white.opacity(0))
                
                Spacer()
                
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
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                
                NavigationLink(destination: AddProfileView(), isActive: $addProfileActive) {
                    Text("")
                }
            }
            .background(
            Image("ajaris_background")
                .resizable())
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        /*UINavigationBar.appearance().backgroundColor = UIColor(red: 11 / 255, green: 138 / 255, blue: 202 / 255, alpha: 1.0)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white]*/
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
