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
        VStack {
            List(float.events) { event in
                EventCardView(event: event)
                    .listRowBackground(Color.black)
                    .listRowSeparator(.hidden)
            }
            .refreshable {
                await float.getEvents()
            }

            Button(action: { showSheet.toggle() }) {
                Label("Create A New Event", systemImage: "plus.circle")
                    .foregroundColor(Color(hex: fclModel.defaultColorHex))
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: Color(hex: fclModel.defaultColorHex), radius: 10.0)
                            .foregroundColor(Color(hex: fclModel.defaultColorHex))
                    )
            }
            .padding()
        }
        .sheet(isPresented: $showSheet) {
            GroupCreateView(showSheet: $showSheet)
        }
    }
}
