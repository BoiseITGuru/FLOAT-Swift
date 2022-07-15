//
//  GroupListView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/14/22.
//

import SwiftUI

struct GroupListView: View {
    @EnvironmentObject var fclModel: FCLModel
    
    var body: some View {
        VStack {
            List(fclModel.floatGroups, id: \.id) { group in
                Text(group.name)
            }
            
            Button(action: {  }) {
                Label("Create A New Group", systemImage: "plus.circle")
                    .foregroundColor(Color(hex: fclModel.floatColorHex))
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: Color(hex: fclModel.floatColorHex), radius: 10.0)
                            .foregroundColor(Color(hex: fclModel.floatColorHex))
                    )
            }
            .padding()
        }
        .onAppear {
            fclModel.getGroups()
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
