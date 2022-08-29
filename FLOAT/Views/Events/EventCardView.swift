//
//  EventCardView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import SwiftUI
import FLOATSwiftSDK

struct EventCardView: View {
    let event: FLOATEventMetadata
    
    var body: some View {
        NavigationLink(destination: Text("Event Details")) {
            HStack {
                IPFSImage(cid: event.image)
                    .frame(width: 50, height: 50)
                Text(event.name)
            }
        }
    }
}
