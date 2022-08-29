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
            HStack(spacing: 3) {
                IPFSImage(cid: event.image)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 3) {
                    Text(event.name)
                        .font(.headline)
                    HStack {
                        Text("# Claimed: \(event.totalSupply)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Created: \(event.formatedDatedCreated)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(15)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(type: .accentColor), lineWidth: 3)
        )
    }
}
