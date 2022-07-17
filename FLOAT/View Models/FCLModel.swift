//
//  FCLModel.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/7/22.
//

import BigInt
import Combine
import CryptoKit
import FCL
import Flow
import Foundation
import SafariServices
import SwiftUI
import LocalAuthentication
import FindSwiftSDK

class FCLModel: NSObject, ObservableObject {
    @Published var defaultColorHex = "38e8c6"

    @Published var FLOAT = float

    @Published var FIND = find

    @Published var env: Flow.ChainID = .testnet

    @Published var loggedIn = false

    @Published var address: String = ""

    @Published var provider: FCLProvider = .blocto

    @Published var isShowWeb: Bool = false

    @Published var isPresented: Bool = false


    @Published var currentObject: String = ""

    private var cancellables = Set<AnyCancellable>()

    let defaults = UserDefaults.standard

    override init() {
        super.init()
        let metadata = FCL.Metadata(appName: "FLOATs", appIcon: "https://placekitten.com/g/200/200", location: "https://floats.city")

        fcl.config(metadata: metadata, env: env, provider: provider)

        switch self.env {
        case .mainnet:
            fcl.config
                .put(.scope, value: "email")
                .put("0xFUSD", value: "0x3c5959b568896393")
                .put("0xFLOAT", value: "0x2d4c3caffbeab845")
                .put("0xCORE", value: "0x1d7e57aa55817448")
                .put("0xFLOWTOKEN", value: "0x1654653399040a61")
                .put("0xFUNGIBLETOKEN", value: "0xf233dcee88fe0abe")
                .put("0xFN", value: "0x0afe396ebc8eee65")
                .put("0xFIND", value: "0x097bafa4e0b48eef")
                .put("0xFLOWSTORAGEFEES", value: "0xe467b9dd11fa00df")
        case .testnet:
            fcl.config
                .put(.scope, value: "email")
                .put("0xFUSD", value: "0x3c5959b568896393")
                .put("0xFLOAT", value: "0x0afe396ebc8eee65")
                .put("0xCORE", value: "0x631e88ae7f1d7c20")
                .put("0xFLOWTOKEN", value: "0x7e60df042a9c0868")
                .put("0xFUNGIBLETOKEN", value: "0x9a0766d93b6608b7")
                .put("0xFN", value: "0x0afe396ebc8eee65")
                .put("0xFIND", value: "0x35717efbbce11c74")
                .put("0xFLOWSTORAGEFEES", value: "0x8c5303eaa26202d6")
        default:
            fcl.config
                .put(.scope, value: "email")
                .put("0xFUSD", value: "0x3c5959b568896393")
                .put("0xFLOAT", value: "0x0afe396ebc8eee65")
                .put("0xCORE", value: "0x631e88ae7f1d7c20")
                .put("0xFLOWTOKEN", value: "0x7e60df042a9c0868")
                .put("0xFUNGIBLETOKEN", value: "0x9a0766d93b6608b7")
                .put("0xFN", value: "0x0afe396ebc8eee65")
                .put("0xFIND", value: "0x35717efbbce11c74")
                .put("0xFLOWSTORAGEFEES", value: "0x8c5303eaa26202d6")
        }
    }

    func changeWallet() {
        fcl.changeProvider(provider: provider, env: env)
    }

    func authn() async {
        do {
            let result = try await fcl.authenticate()
            await MainActor.run {
                self.address = result.address ?? ""

                if self.address != "" {
                    self.defaults.set(self.address, forKey: "address")
                    self.loggedIn = true
                }
            }

            await self.FLOAT.floatIsSetup()
            await self.FIND.checkFindProfile()
        } catch {
            // TODO: Error handling
            print(error)
        }
    }

//    func faceIdAuth() {
//        let context = LAContext()
//        var error: NSError?
//        let address = defaults.object(forKey: "address") as? String ?? ""
//
//        //Check If Address has been set
//        if address != "" {
//            // check whether biometric authentication is possible
//            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//                // it's possible, so go ahead and use it
//                let reason = "Face ID is used to keep you logged into your wallet between app loads"
//
//                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                    // authentication has now completed
//                    if success {
//                        // authenticated successfully
//                        self.address = "123465"
//                    } else {
//                        // there was a problem
//                        self.signOut()
//                    }
//                }
//            } else {
//                // no biometrics
//            }
//        }
//    }

    func signOut() {
        self.defaults.removeObject(forKey: "address")
        self.address = ""
        self.loggedIn = false
        fcl.unauthenticate()
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<SafariView>) {}
}
