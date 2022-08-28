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
                IPFSImage(cid: group.image)
                    .frame(width: 50, height: 50)
                Text(group.name)
            }
        }
    }
}
