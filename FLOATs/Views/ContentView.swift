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
            if !fclModel.loggedIn {
                SignIn()
            } else {
                TabView {
                    Text("FLOATs")
                        .tabItem {
                            Image(systemName: "greetingcard.fill")
                            Text("FLOATs")
                        }
                    Text("Events")
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
                .accentColor(Color(hex: fclModel.defaultColorHex))
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("FLOATs")
            }
        }
//        .onAppear(perform: fclModel.faceIdAuth)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
