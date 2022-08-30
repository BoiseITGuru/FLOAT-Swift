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
    @State private var searchText = ""
    @State var showSheet = false

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(searchResults) { event in
                            EventCardView(event: event)
                                .padding(.horizontal, 1)
                                .padding(.bottom, 5)
                        }
                    }
                }
                .searchable(text: $searchText)
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
    
    var searchResults: [FLOATEventMetadata] {
        if searchText.isEmpty {
            return float.events
        } else {
            return float.events.filter { $0.name.contains(searchText) }
        }
    }
}
