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
                Spacer()
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
