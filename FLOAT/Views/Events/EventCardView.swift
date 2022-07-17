//
//  EventCardView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import SwiftUI

struct EventCardView: View {
    let event: FLOATEventMetadata
    
    var body: some View {
        NavigationLink(destination: Text("Event Details")) {
            HStack {
                AsyncImage(url: URL(string: "https://ipfs.infura.io/ipfs/\(event.image)"), scale: 2) { image in
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                    .frame(width: 50, height: 50)
                Text(event.name)
            }
        }
    }
}
