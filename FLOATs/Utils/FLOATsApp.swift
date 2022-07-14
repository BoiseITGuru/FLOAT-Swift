//
//  FLOATsApp.swift
//  FLOATs
//
//  Created by Brian Pistone on 7/13/22.
//

import SwiftUI

@main
struct FLOATsApp: App {
    @StateObject var fclModel = FCLModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fclModel)
        }
    }
}
