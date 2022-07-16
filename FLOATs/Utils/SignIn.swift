//
//  SignIn.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/8/22.
//

import SwiftUI
import FCL

struct SignIn: View {
    @EnvironmentObject var fclModel: FCLModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 100)
            Button(action: { Task { await fclModel.authn() } }) {
                Label("Sign In", systemImage: "person")
                    .foregroundColor(Color(hex: fclModel.defaultColorHex))
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: Color(hex: fclModel.defaultColorHex), radius: 10.0)
                            .foregroundColor(Color(hex: fclModel.defaultColorHex))
                    )
            }

            Form {
                Picker("Wallet Provider", selection: $fclModel.provider, content: {
                    Text("Dapper").tag(FCLProvider.dapper)
                    Text("Blocoto").tag(FCLProvider.blocto)
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
