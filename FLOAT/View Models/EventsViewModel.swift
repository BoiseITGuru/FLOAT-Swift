//
//  EventsViewModel.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation
import SwiftUI

class EventsViewModel: ObservableObject {
    @Published var events: [FLOATEventMetadata] = []

    func getEvents() async {
        await float.getEvents()

        await MainActor.run {
            events = float.events
        }
    }
}
