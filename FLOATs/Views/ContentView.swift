//
//  ContentView.swift
//  FLOATs
//
//  Created by Brian Pistone on 7/13/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fclModel: FCLModel
    
    var body: some View {
        NavigationView {
            if !fclModel.loggedIn {
                SignIn()
            } else {
                if !fclModel.floatSetup {
                    SetupAccountView()
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
                        Text("Groups")
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
                    .accentColor(Color(hex: fclModel.floatColorHex))
                    .navigationBarTitleDisplayMode(.inline)
                }
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
