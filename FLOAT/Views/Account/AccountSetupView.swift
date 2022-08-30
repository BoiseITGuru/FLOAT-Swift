//
//  AccountSetupView.swift
//  FLOAT
//
//  Created by BoiseITGuru on 8/29/22.
//

import SwiftUI
import FLOATSwiftSDK

struct AccountSetupView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var float = sharedFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Before you can use the FLOAT Platform or receive any FLOATs your account must be setup")
            Button(action: { Task { float.setupFloatAccount } }) {
                Text("Setup Account")
                    .font(.title2)
                    .foregroundColor(Color(type: .textColor))
            }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color(type: .accentColor))
                .cornerRadius(15)
                .buttonStyle(PlainButtonStyle())
        }
        .padding(15)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(type: .accentColor), lineWidth: 3)
        )
    }
}

struct AccountSetupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetupView()
    }
}
