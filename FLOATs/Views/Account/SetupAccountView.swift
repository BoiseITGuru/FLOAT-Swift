//
//  SetupAccountView.swift
//  FLOATs
//
//  Created by Brian Pistone on 7/14/22.
//

import SwiftUI

struct SetupAccountView: View {
    @EnvironmentObject var fclModel: FCLModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 100)
            if fclModel.checkingAccount {
                Text("Please wait while we verify your account is setup properly")
            } else {
                Text("To get the best results please setup your account before proceeding")
                Button(action: { fclModel.setupFloatAccount() }) {
                    Label("Setup Account", systemImage: "person")
                        .foregroundColor(Color(hex: fclModel.floatColorHex))
                        .padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                                .shadow(color: Color(hex: fclModel.floatColorHex), radius: 10.0)
                                .foregroundColor(Color(hex: fclModel.floatColorHex))
                        )
                }
            }
        }
        .onAppear {
            fclModel.floatIsSetup()
        }
    }
}

struct SetupAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SetupAccountView()
    }
}
