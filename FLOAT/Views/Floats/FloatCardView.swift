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
            HStack(spacing: 3) {
                IPFSImage(cid: float.float.eventImage)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 3) {
                    Text(float.float.eventName)
                        .font(.headline)
                    HStack {
                        Text("Serial #\(float.float.serial)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Received: \(float.float.formatedDatedReceived)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
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
