//
//  SignIn.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/8/22.
//

import SwiftUI

struct SignIn: View {
    @EnvironmentObject var fclModel: FCLModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 100)
            Button(action: { fclModel.authn() }) {
                Label("Sign In", systemImage: "person")
                    .foregroundColor(Color(hex: fclModel.floatColorHex))
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: Color(hex: fclModel.floatColorHex), radius: 10.0)
                            .foregroundColor(Color(hex: fclModel.floatColorHex))
                    )
            }

            Form {
                Picker("Wallet Provider", selection: $fclModel.provider, content: {
                    Text("Dapper").tag(Provider.dapper)
                    Text("Blocoto").tag(Provider.blocto)
                }).onChange(of: fclModel.provider, perform: { _ in
                    fclModel.changeWallet()
                })
            }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
