//
//  SettingsView.swift
//  Boise's Finest DAO
//
//  Created by Brian Pistone on 7/7/22.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var fclModel: FCLModel
    
    var body: some View {
        List {
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
                        Text(fclModel.findName)
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
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
