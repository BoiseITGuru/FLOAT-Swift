//
//  GroupCardView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/14/22.
//

import SwiftUI
import FLOATSwiftSDK

struct GroupCardView: View {
    let group: FloatGroup
    
    var body: some View {
        NavigationLink(destination: GroupDetailView(group: group)) {
            HStack {
                AsyncImage(url: URL(string: "https://ipfs.infura.io/ipfs/\(group.image)"), scale: 2) { image in
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                    .frame(width: 50, height: 50)
                Text(group.name)
            }
        }
    }
}
