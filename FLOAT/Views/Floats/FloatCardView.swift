//
//  FloatCardView.swift
//  FLOAT
//
//  Created by BoiseITGuru on 8/28/22.
//

import SwiftUI
import FLOATSwiftSDK

struct FloatCardView: View {
    let float: CombinedFloatMetadata
    
    var body: some View {
        NavigationLink(destination: Text("FLOAT Details")) {
            HStack {
                IPFSImage(cid: float.float.eventImage)
                    .frame(width: 50, height: 50)
                Text(float.float.eventName)
            }
        }
    }
}
