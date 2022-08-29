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
            Text("FLOAT")
                .font(.largeTitle)
                .foregroundColor(Color(type: .accentColor))
                .padding(.bottom, 20)
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 100)
            
            Button(action: { Task { await fclModel.authn() } }) {
                Text("Log In")
                    .font(.title2)
                    .foregroundColor(Color(type: .textColor))
            }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color(type: .accentColor))
                .cornerRadius(15)
                .buttonStyle(PlainButtonStyle())

            if fclModel.env == .mainnet || fclModel.env == .testnet {
                Picker("Wallet Provider", selection: $fclModel.provider, content: {
                    Text("Blocto").tag(FCLProvider.blocto)
                    Text("Dapper").tag(FCLProvider.dapper)
                }).onChange(of: fclModel.provider, perform: { _ in
                    fclModel.changeWallet()
                })
            }
        }
        .padding(.horizontal, 20)
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
