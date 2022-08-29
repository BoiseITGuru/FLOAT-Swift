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
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                LazyVStack {
                    ForEach(float.floats) { float in
                        FloatCardView(float: float)
                            .padding(.horizontal, 1)
                            .padding(.bottom, 5)
                    }
                }
            }
            .padding(.horizontal, 20)
        }.onAppear() {
            Task {
                await float.getFloats()
            }
        }
    }
}

struct FloatsListView_Previews: PreviewProvider {
    static var previews: some View {
        FloatsListView()
    }
}
