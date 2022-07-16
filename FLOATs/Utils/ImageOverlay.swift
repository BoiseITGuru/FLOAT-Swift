//
//  ImageOverlay.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/8/22.
//

import SwiftUI

struct ImageOverlay: View {
    @EnvironmentObject var fclModel: FCLModel
    var text: String
    var font: Font
    
    var body: some View {
        ZStack {
            Text(text)
                .font(font)
                .padding(6)
                .foregroundColor(Color(hex: fclModel.floatColorHex))
        }
            .background(Color.black)
            .opacity(0.8)
            .cornerRadius(10.0)
            .padding(6)
    }
}
