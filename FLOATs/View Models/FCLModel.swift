//
//  FCLModel.swift
//  Boise's Finest DAO
//
//  Created by Brian Pistone on 7/7/22.
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

class FCLModel: NSObject, ObservableObject {
    @Published var floatColorHex = "38e8c6"
    
    @Published var floatSetup = false
    
    @Published var loggedIn = false
    
    @Published var address: String = ""

    @Published var preAuthz: String = ""

    @Published var provider: Provider = .blocto

    @Published var isShowWeb: Bool = false

    @Published var isPresented: Bool = false

    @Published var accountLookup: String = ""

    @Published var currentObject: String = ""

    @Published var message: String = ""

    @Published var balance: String = ""
    @Published var FUSDBalance: String = ""

    @Published var script: String =
        """
        pub struct SomeStruct {
          pub var x: Int
          pub var y: Int

          init(x: Int, y: Int) {
            self.x = x
            self.y = y
          }
        }

        pub fun main(): [SomeStruct] {
          return [SomeStruct(x: 1, y: 2),
                  SomeStruct(x: 3, y: 4)]
        }
        """

    let setupAccountTx =
        """
             import FLOAT from 0xFLOAT
             import NonFungibleToken from 0xCORE
             import MetadataViews from 0xCORE
             import GrantedAccountAccess from 0xFLOAT
             transaction {
               prepare(acct: AuthAccount) {
                 // SETUP COLLECTION
                 if acct.borrow<&FLOAT.Collection>(from: FLOAT.FLOATCollectionStoragePath) == nil {
                     acct.save(<- FLOAT.createEmptyCollection(), to: FLOAT.FLOATCollectionStoragePath)
                     acct.link<&FLOAT.Collection{NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection, FLOAT.CollectionPublic}>
                             (FLOAT.FLOATCollectionPublicPath, target: FLOAT.FLOATCollectionStoragePath)
                 }
                 // SETUP FLOATEVENTS
                 if acct.borrow<&FLOAT.FLOATEvents>(from: FLOAT.FLOATEventsStoragePath) == nil {
                   acct.save(<- FLOAT.createEmptyFLOATEventCollection(), to: FLOAT.FLOATEventsStoragePath)
                   acct.link<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic, MetadataViews.ResolverCollection}>
                             (FLOAT.FLOATEventsPublicPath, target: FLOAT.FLOATEventsStoragePath)
                 }
                 // SETUP SHARED MINTING
                 if acct.borrow<&GrantedAccountAccess.Info>(from: GrantedAccountAccess.InfoStoragePath) == nil {
                     acct.save(<- GrantedAccountAccess.createInfo(), to: GrantedAccountAccess.InfoStoragePath)
                     acct.link<&GrantedAccountAccess.Info{GrantedAccountAccess.InfoPublic}>
                             (GrantedAccountAccess.InfoPublicPath, target: GrantedAccountAccess.InfoStoragePath)
                 }
               }
               execute {
                 log("Finished setting up the account for FLOATs.")
               }
             }
        """

    private var cancellables = Set<AnyCancellable>()
    
    let defaults = UserDefaults.standard

    override init() {
        super.init()
        fcl.config
            .put(.title, value: "Boise's Finest DAO")
            .put(.wallet, value: "https://fcl-discovery.onflow.org/testnet/authn")
            .put(.accessNode, value: "https://access-testnet.onflow.org")
            .put(.authn, value: provider.endpoint)
            .put(.location, value: "https://BoisesFinestDAO.app")
            .put(.env, value: "testnet")
            .put(.scope, value: "email")

        fcl.config
            .put("0xFUSD", value: "0x3c5959b568896393")
            .put("0xFLOAT", value: "0x0afe396ebc8eee65")
            .put("0xCORE", value: "0x631e88ae7f1d7c20")
            .put("0xFLOWTOKEN", value: "0x7e60df042a9c0868")
            .put("0xFUNGIBLETOKEN", value: "0x9a0766d93b6608b7")
            .put("0xFN", value: "0x0afe396ebc8eee65")
            .put("0xFIND", value: "0xa16ab1d0abde3625")
            .put("0xFLOWSTORAGEFEES", value: "0x8c5303eaa26202d6")
    }

    func changeWallet() {
        fcl.config.put(.authn, value: provider.endpoint)
    }
    
    func setupFloatAccount() {
        fcl.send([
            .transaction(setupAccountTx),
            .limit(1000),
        ])
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case let .failure(error) = completion {
                // TODO: Error Handling
                self.preAuthz = error.localizedDescription
            }
        } receiveValue: { txId in
            self.floatSetup = true
            self.preAuthz = txId
        }.store(in: &cancellables)
        
        print(self.preAuthz)
    }
    
    func floatIsSetup() {
        if self.loggedIn {
            fcl.query {
                cadence {
                    """
                      import FLOAT from 0xFLOAT
                      import NonFungibleToken from 0xCORE
                      import MetadataViews from 0xCORE
                      import GrantedAccountAccess from 0xFLOAT
                    
                      pub fun main(accountAddr: Address): Bool {
                        let acct = getAccount(accountAddr)
                        if acct.getCapability<&FLOAT.Collection{FLOAT.CollectionPublic}>(FLOAT.FLOATCollectionPublicPath).borrow() == nil {
                            return false
                        }
                      
                        if acct.getCapability<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic}>(FLOAT.FLOATEventsPublicPath).borrow() == nil {
                          return false
                        }
                      
                        if acct.getCapability<&GrantedAccountAccess.Info{GrantedAccountAccess.InfoPublic}>(GrantedAccountAccess.InfoPublicPath).borrow() == nil {
                            return false
                        }
                        return true
                      }
                    """
                }
                
                arguments {
                    [.address(Flow.Address(hex: self.address))]
                }
                
                gasLimit {
                    1000
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { block in
                print(block)
                self.floatSetup = block.fields?.value.toBool() ?? false
            }.store(in: &cancellables)

        } else {
            // TODO: Error Handling
            print("Error - Not Logged In")
        }
    }

    func queryFUSD(address: String) {
        fcl.query {
            cadence {
                """
                import FungibleToken from 0xFungibleToken
                import FUSD from 0xFUSD

                pub fun main(account: Address): UFix64 {
                  let receiverRef = getAccount(account).getCapability(/public/fusdBalance)!
                    .borrow<&FUSD.Vault{FungibleToken.Balance}>()

                  return receiverRef!.balance
                }
                """
            }

            arguments {
                [.address(Flow.Address(hex: address))]
            }

            gasLimit {
                1000
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case let .failure(error) = completion {
                print(error)
            }
        } receiveValue: { block in
            self.FUSDBalance = "\(String(block.fields?.value.toUFix64() ?? 0.0)) FUSD"
        }.store(in: &cancellables)
    }

    func authn() {
        fcl.authenticate()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    // TODO: Proper Error handling here!!!
                    self.address = error.localizedDescription
                }
            } receiveValue: { result in
                self.address = result.address ?? ""
                self.defaults.set(self.address, forKey: "address")
                self.loggedIn = true
            }.store(in: &cancellables)
    }

    func send(script: String, params: [Flow.Cadence.FValue]) {
        fcl.mutate {
            cadence {
                script
            }

            arguments {
                params
            }

            gasLimit {
                1000
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case let .failure(error) = completion {
                self.preAuthz = error.localizedDescription
            }
        } receiveValue: { txId in
            print(txId)
            self.preAuthz = txId
        }.store(in: &cancellables)
    }

    func authz() {
        fcl.send([
            .transaction(
                """
                   transaction(test: String, testInt: Int) {
                       prepare(signer: AuthAccount) {
                            log(signer.address)
                            log(test)
                            log(testInt)
                       }
                   }
                """
            ),
            .args([.string("Test2"), .int(1)]),
            .limit(1000),
        ])
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case let .failure(error) = completion {
                self.preAuthz = error.localizedDescription
            }
        } receiveValue: { txId in
            self.preAuthz = txId
        }.store(in: &cancellables)
    }
    
    func faceIdAuth() {
        let context = LAContext()
        var error: NSError?
        let address = defaults.object(forKey: "address") as? String ?? ""

        //Check If Address has been set
        if address != "" {
            // check whether biometric authentication is possible
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // it's possible, so go ahead and use it
                let reason = "Face ID is used to keep you logged into your wallet between app loads"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    // authentication has now completed
                    if success {
                        // authenticated successfully
                        self.address = "123465"
                    } else {
                        // there was a problem
                        self.signOut()
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
    
    func signOut() {
        self.defaults.removeObject(forKey: "address")
        self.address = ""
        self.loggedIn = false
        fcl.unauthenticate()
    }
}

enum Provider: Int {
    case dapper
    case blocto

    var endpoint: String {
        switch self {
        case .dapper:
            return "https://dapper-http-post.vercel.app/api/authn"
        case .blocto:
            return "https://flow-wallet-testnet.blocto.app/api/flow/authn"
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<SafariView>) {}
}
