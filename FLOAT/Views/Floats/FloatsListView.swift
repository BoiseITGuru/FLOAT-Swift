//
//  FloatsListView.swift
//  FLOAT
//
//  Created by BoiseITGuru on 8/28/22.
//

import SwiftUI
import FLOATSwiftSDK

struct FloatsListView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var float = sharedFloat
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                LazyVStack {
                    ForEach(searchResults) { float in
                        FloatCardView(float: float)
                            .padding(.horizontal, 1)
                            .padding(.bottom, 5)
                    }
                }
            }
            .searchable(text: $searchText)
            .padding(.horizontal, 20)
        }.onAppear() {
            Task {
                await float.getFloats()
            }
        }
    }
    
    var searchResults: [CombinedFloatMetadata] {
        if searchText.isEmpty {
            return float.floats
        } else {
            return float.floats.filter { $0.float.eventName.contains(searchText) }
        }
    }
}

struct FloatsListView_Previews: PreviewProvider {
    static var previews: some View {
        FloatsListView()
    }
}
