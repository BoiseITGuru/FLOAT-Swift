//
//  LoadingView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/15/22.
//

import SwiftUI

struct LoadingView: View {
    @Binding var loadingMsg: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 50)
            Text(loadingMsg)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(20)
        }
    }
}
