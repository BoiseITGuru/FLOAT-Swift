//
//  EventsListView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import SwiftUI
import FLOATSwiftSDK

struct EventsListView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var float = sharedFloat

    @State var showSheet = false

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(float.events) { event in
                            EventCardView(event: event)
                                .padding(.horizontal, 1)
                                .padding(.bottom, 5)
                        }
                    }
                }
                
                Button(action: { showSheet.toggle() }) {
                    Text("Create A New Event")
                        .font(.title2)
                        .foregroundColor(Color(type: .textColor))
                }
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color(type: .accentColor))
                    .cornerRadius(15)
                    .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $showSheet) {
            GroupCreateView(showSheet: $showSheet)
        }
        .onAppear() {
            Task {
                await float.getEvents()
            }
        }
    }
}
