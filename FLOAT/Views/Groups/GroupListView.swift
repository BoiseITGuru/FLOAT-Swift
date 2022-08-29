//
//  GroupListView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/14/22.
//

import SwiftUI
import FLOATSwiftSDK

struct GroupListView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var float = sharedFloat
    @State var showSheet = false

    var body: some View {
        VStack {
            List(float.groups) { group in
                GroupCardView(group: group)
            }.refreshable {
                await float.getGroups()
            }

            Button(action: { showSheet.toggle() }) {
                Label("Create A New Group", systemImage: "plus.circle")
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

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
