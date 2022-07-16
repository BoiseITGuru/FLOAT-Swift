//
//  GroupCreateView.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/14/22.
//

import SwiftUI

struct GroupCreateView: View {
    @EnvironmentObject var fclModel: FCLModel
    @Binding var showSheet: Bool
    @State var groupName = ""
    @State var groupDescription = ""
    
    var body: some View {
        Form {
            Section("Group Name") {
                TextField("Name", text: $groupName)
            }
            
            Section("Group Description") {
                TextEditor(text: $groupDescription)
                    .frame(height: 200)
            }
            
            Button(action: {  }) {
                Text("Create Group")
            }
        }
    }
}
