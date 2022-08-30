//
//  AccountProfileView.swift
//  FLOAT
//
//  Created by BoiseITGuru on 8/29/22.
//

import SwiftUI
import FindSwiftSDK
import CachedAsyncImage

struct AccountProfileView: View {
    @EnvironmentObject var fclModel: FCLModel
    @ObservedObject var find = sharedFind
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                if find.profile?.avatar != nil {
                    CachedAsyncImage(url: URL(string: find.profile?.avatar ?? ""), scale: 2) { image in
                        image
                          .resizable()
                          .clipShape(Circle())
                          .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                        .frame(width: 80, height: 80)
                        .padding(.horizontal, 10)
                } else {
                    Image("profile")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.horizontal, 10)
                }
                
                VStack(alignment: .leading) {
                    Text(find.profile?.name ?? fclModel.address)
                        .font(.title)
                        .foregroundColor(Color(type: .accentColor))
                        .lineLimit(1)
                    Text("Some other info probably")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            
            Button(action: { Task { fclModel.signOut() } }) {
                Text("Sign Out")
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

struct AccountProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AccountProfileView()
    }
}
