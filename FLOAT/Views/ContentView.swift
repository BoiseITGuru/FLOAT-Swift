//
//  ContentView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/13/22.
//

import SwiftUI
import TabBarUIAction

struct ContentView: View {
    @EnvironmentObject var fclModel: FCLModel
    @State private var currentTab: TabPosition = .tab1
    @State private var showModal: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                if !fclModel.loggedIn {
                    SignIn()
                } else {
                    TabBarUIAction(
                        currentTab: $currentTab,
                        showModal: $showModal,
                        colors: Colors(
                            tabBarBackgroundColor: Color(type: .backgroundColor),
                            tabItemsColors: TabItemsColors(
                                tabItemColor: Color(type: .accentColor),
                                tabItemSelectionColor: Color(type: .accentColor)
                            )
                        )
                    ) {
                        TabScreen(
                            tabItem: TabItemContent(
                                systemImageName: "greetingcard.fill",
                                text: "FLOATs",
                                font: Font.system(size: 14))) {
                                    FloatsListView()
                        }
                        
                        TabScreen(
                            tabItem: TabItemContent(
                                systemImageName: "greetingcard.fill",
                                text: "EVENTs",
                                font: Font.system(size: 14))) {
                                    EventsListView()
                        }
                        
                        TabModal {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 55, height: 55, alignment: .center)
                                .foregroundColor(Color(type: .accentColor))
                                .background(Color(type: .backgroundColor))
                                .cornerRadius(55/2)
                                .overlay(RoundedRectangle(cornerRadius: 55/2).stroke(Color(type: .backgroundColor), lineWidth: 2))
                                .accessibility(identifier: "TabBarModalButton")
                        } content: {
                            Text("Create Event Screen")
                        }
                        
                        TabScreen(
                            tabItem: TabItemContent(
                                systemImageName: "greetingcard.fill",
                                text: "GROUPs",
                                font: Font.system(size: 14))) {
                                    GroupListView()
                        }
                        
                        TabScreen(
                            tabItem: TabItemContent(
                                systemImageName: "greetingcard.fill",
                                text: "ACCOUNT",
                                font: Font.system(size: 14))) {
                                    AccountView()
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
