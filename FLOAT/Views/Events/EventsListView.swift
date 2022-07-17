//
//  EventsListView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import SwiftUI

struct EventsListView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var events = EventsViewModel()

    @State var showSheet = false

    var body: some View {
        VStack {
            List(events.events) { event in
                EventCardView(event: event)
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
        .onAppear {
            Task {
                await events.getEvents()
            }
        }
        .sheet(isPresented: $showSheet) {
            GroupCreateView(showSheet: $showSheet)
        }
    }
}
