//
//  SettingsView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/7/22.
//

import SwiftUI
import FLOATSwiftSDK
import FindSwiftSDK

struct AccountView: View {
    @EnvironmentObject var fclModel: FCLModel
    @State var sharedMinter = ""
    @State var showFINDProfile = false

    var body: some View {
        List {
            Section(header: Text("Account - FIND Profile")) {
                HStack(spacing: 10) {
                    if find.profile?.avatar != nil {
                        AsyncImage(url: URL(string: find.profile?.avatar ?? ""), scale: 2) { image in
                            image
                              .resizable()
                              .clipShape(Circle())
                              .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                            .frame(width: 80, height: 80)
                    } else {
                        Image("profile")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        Text(find.profile?.name ?? fclModel.address)
                            .font(.title)
                            .lineLimit(1)
                        Text("Some other info probably")
                            .font(.subheadline)
                    }
                }
                Button(action: { fclModel.signOut() }) {
                    Text("Sign Out")
                }
            }

            if !float.isSetup() {
                Section("Setup Account") {
                    Text("Before you can use the FLOAT Platform or receive any FLOATs your account must be setup")
                    Button(action: { Task { float.setupFloatAccount } }) {
                        Text("Setup Account")
                    }
                }
            }

            Section(header: Text("Shared Minting")) {
                Text("Share this account with another address and allow them to create events on your behalf. Add an address below and click on 'Add Shared Minter'. Do at your own risk!")
                TextField("0x00000000000", text: $sharedMinter)
                Button(action: { Task { await float.addSharedMinter(address: sharedMinter) } }) {
                    Text("Add Shared Minter")
                }
                Text("BEWARE: Anyone with access to the address above will be able to control this account on FLOAT.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(Color.red)
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
