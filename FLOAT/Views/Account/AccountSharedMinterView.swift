//
//  AccountSharedMinterView.swift
//  FLOAT
//
//  Created by BoiseITGuru on 8/29/22.
//

import SwiftUI
import FLOATSwiftSDK

struct AccountSharedMinterView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var float = sharedFloat
    @State var sharedMinter = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Share this account with another address and allow them to create events on your behalf. Add an address below and click on 'Add Shared Minter'. Do at your own risk!")
                .foregroundColor(.white)
            
            TextField("", text: $sharedMinter)
                .foregroundColor(.white)
                .placeholder(when: sharedMinter.isEmpty) {
                    Text("0x00000000000")
                        .foregroundColor(Color(type: .textColor))
                }
            
            Button(action: { Task { await float.addSharedMinter(address: sharedMinter) } }) {
                Text("Add Shared Minter")
                    .font(.title2)
                    .foregroundColor(Color(type: .textColor))
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color(type: .accentColor))
            .cornerRadius(15)
            .buttonStyle(PlainButtonStyle())
            
            Text("BEWARE: Anyone with access to the address above will be able to control this account on FLOAT.")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(Color.red)
        }
        .padding(15)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(type: .accentColor), lineWidth: 3)
        )
    }
}

struct AccountSharedMinterView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSharedMinterView()
    }
}
