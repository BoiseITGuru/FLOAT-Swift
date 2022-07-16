//
//  SettingsView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/7/22.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var fclModel: FCLModel
    @State var sharedMinter = ""
    
    var body: some View {
        List {
            Section(header: Text("Account")) {
                HStack(spacing: 10) {
                    Image("profile")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        if fclModel.findName == "" {
                            Text(fclModel.address)
                                .font(.title)
                                .lineLimit(1)
                        } else {
                            Text("\(fclModel.findName).find")
                                .font(.title)
                                .lineLimit(1)
                        }
                        Text("Some other info probably")
                            .font(.subheadline)
                    }
                }
                
                Button(action: { fclModel.signOut() }) {
                    Text("Sign Out")
                }
            }
            
            Section(header: Text("Shared Minting")) {
                Text("Share this account with another address and allow them to create events on your behalf. Add an address below and click on 'Add Shared Minter'. Do at your own risk!")
                TextField("0x00000000000", text: $sharedMinter)
                Button(action: { fclModel.addSharedMinter(address: sharedMinter) }) {
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
