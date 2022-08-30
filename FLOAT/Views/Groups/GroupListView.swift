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
        ZStack {
            BackgroundView()
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(float.groups) { group in
                            GroupCardView(group: group)
                        }
                    }
                }
                
                Button(action: { showSheet.toggle() }) {
                    Text("Create A New Group")
                        .font(.title2)
                        .foregroundColor(Color(type: .textColor))
                }
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color(type: .accentColor))
                    .cornerRadius(15)
                    .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $showSheet) {
            GroupCreateView(showSheet: $showSheet)
        }
        .onAppear() {
            Task {
                await float.getGroups()
            }
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
