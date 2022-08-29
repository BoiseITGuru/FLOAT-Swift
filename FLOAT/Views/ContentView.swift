//
//  ContentView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/13/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fclModel: FCLModel

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                if !fclModel.loggedIn {
                    SignIn()
                } else {
                    TabView {
                        FloatsListView()
                            .tabItem {
                                Image(systemName: "greetingcard.fill")
                                Text("FLOATs")
                            }
                        EventsListView()
                            .tabItem {
                                Image(systemName: "greetingcard.fill")
                                Text("Events")
                            }
                        GroupListView()
                            .tabItem {
                                Image(systemName: "greetingcard.fill")
                                Text("Groups")
                            }
                        AccountView()
                            .tabItem {
                                Image(systemName: "greetingcard.fill")
                                Text("Account")
                            }
                    }
                    .accentColor(Color(type: .accentColor))
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("FLOAT")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
