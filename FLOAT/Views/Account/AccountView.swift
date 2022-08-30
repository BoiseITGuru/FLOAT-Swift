//
//  SettingsView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/7/22.
//

import SwiftUI
import FindSwiftSDK
import FLOATSwiftSDK
import CachedAsyncImage

struct AccountView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var float = sharedFloat
    @ObservedObject var find = sharedFind
    @State var sharedMinter = ""
    @State var showFINDProfile = false

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                AccountProfileView()
                    .padding(.vertical, 20)

                if !float.isSetup() {
                    AccountSetupView()
                        .padding(.bottom, 20)
                }

                AccountSharedMinterView()
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
