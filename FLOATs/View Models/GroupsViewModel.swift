//
//  GroupsViewModel.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation
import SwiftUI

class GroupsViewModel: ObservableObject {
    @Published var groups: [FloatGroup] = []
    
    func getGroups() async {
        await float.getGroups()
        
        await MainActor.run {
            groups = float.groups
        }
    }
}
