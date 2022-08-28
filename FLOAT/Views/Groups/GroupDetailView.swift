//
//  GroupDetailView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/14/22.
//

import SwiftUI
import FLOATSwiftSDK

struct GroupDetailView: View {
    @EnvironmentObject var fclModel: FCLModel

    @State var group: FloatGroup

    var body: some View {
        VStack {
            if let groupImage = group.image {
                VStack {
                    AsyncImage(url: URL(string: "https://ipfs.infura.io/ipfs/\(groupImage)"), scale: 2) { image in
                        image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }.frame(height: 250)
                        .overlay(alignment: .bottomLeading) {
                            ImageOverlay(text: group.name, font: .title)
                        }
                        .padding()
                }
            } else {
                Text(group.name)
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .padding(.bottom)
            }

            Text(group.description)
                .font(.body)
                .padding()

//            List(group.events, id:\.self) { event in
//                Text(event)
//            }
            
//            List {
//                ForEach(Array(group.events.keys.enumerated()), id:\.element) { value, key in
//                    Text(group.events[key]?.description ?? "")
//                }
//            }
        }
        .navigationTitle("Group Details")
//        .onAppear {
//            fclModel.getGroupEvents(events: group.events, address: fclModel.address)
//        }
    }
}
