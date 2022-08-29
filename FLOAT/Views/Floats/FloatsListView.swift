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
        ScrollView {
            LazyVStack {
                
            }
        }
    }
}

struct FloatsListView_Previews: PreviewProvider {
    static var previews: some View {
        FloatsListView()
    }
}
