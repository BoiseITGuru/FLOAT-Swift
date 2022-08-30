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
    @State private var searchText = ""
    @State var showSheet = false

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(searchResults) { group in
                            GroupCardView(group: group)
                        }
                    }
                }
                .searchable(text: $searchText)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $showSheet) {
            GroupCreateView(showSheet: $showSheet)
        }
        .toolbar {
            Button(action: { showSheet.toggle() }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(type: .accentColor))
                    .background(Color(type: .backgroundColor))
                    .cornerRadius(55/2)
                    .overlay(RoundedRectangle(cornerRadius: 55/2).stroke(Color(type: .backgroundColor), lineWidth: 2))
                    .accessibility(identifier: "CreateGroupButton")
            }
        }
        .onAppear() {
            Task {
                await float.getGroups()
            }
        }
    }
    
    var searchResults: [FloatGroup] {
        if searchText.isEmpty {
            return float.groups
        } else {
            return float.groups.filter { $0.name.contains(searchText) }
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
