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

class FCLModel: NSObject, ObservableObject {
    @Published var floatColorHex = "38e8c6"
    
    @Published var checkingAccount = true
    
    @Published var floatSetup = false
    
    @Published var findName = ""
    
    @Published var floatGroups: [FloatGroup] = []
    
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

    private let setupAccountTx =
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
    
    private let addSharedMinterTx =
        """
            import GrantedAccountAccess from 0xFLOAT
            transaction (receiver: Address) {
                let Info: &GrantedAccountAccess.Info

                prepare(acct: AuthAccount) {
                  // set up the FLOAT Collection where users will store their FLOATs
                  if acct.borrow<&GrantedAccountAccess.Info>(from: GrantedAccountAccess.InfoStoragePath) == nil {
                      acct.save(<- GrantedAccountAccess.createInfo(), to: GrantedAccountAccess.InfoStoragePath)
                      acct.link<&GrantedAccountAccess.Info{GrantedAccountAccess.InfoPublic}>
                              (GrantedAccountAccess.InfoPublicPath, target: GrantedAccountAccess.InfoStoragePath)
                  }
                  self.Info = acct.borrow<&GrantedAccountAccess.Info>(from: GrantedAccountAccess.InfoStoragePath)!
                }
                execute {
                  self.Info.addAccount(account: receiver)
                }
            }
        """

    private var cancellables = Set<AnyCancellable>()
    
    let defaults = UserDefaults.standard

    override init() {
        super.init()
        fcl.config
            .put(.title, value: "FLOATs")
            .put(.wallet, value: "https://fcl-discovery.onflow.org/testnet/authn")
            .put(.accessNode, value: "https://access-testnet.onflow.org")
            .put(.authn, value: provider.endpoint)
            .put(.location, value: "https://floats.city")
            .put(.env, value: "testnet")
            .put(.scope, value: "email")

        fcl.config
            .put("0xFUSD", value: "0x3c5959b568896393")
            .put("0xFLOAT", value: "0x0afe396ebc8eee65")
            .put("0xCORE", value: "0x631e88ae7f1d7c20")
            .put("0xFLOWTOKEN", value: "0x7e60df042a9c0868")
            .put("0xFUNGIBLETOKEN", value: "0x9a0766d93b6608b7")
            .put("0xFN", value: "0x0afe396ebc8eee65")
            .put("0xFIND", value: "0x35717efbbce11c74")
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
                    // TODO: Error Handling
                    print(error)
                }
            } receiveValue: { block in
                print(block)
                self.floatSetup = block.fields?.value.toBool() ?? false
                self.checkingAccount = false
            }.store(in: &cancellables)

        } else {
            // TODO: Error Handling
            print("Error - Not Logged In")
        }
    }
    
    func reverseLookupFIND(address: String) {
        fcl.query {
            cadence {
                """
                import FIND, Profile from 0xFIND

                pub fun main(address: Address) :  String? {
                    return FIND.reverseLookup(address)
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
            let find = block.fields?.value.toOptional()
            if let decodedFind = try? JSONSerialization.jsonObject(with: (find?.jsonData!)!, options: .fragmentsAllowed) as? [String: Any],
               let decodedFindValue = decodedFind["value"] as? String {
                self.findName = decodedFindValue
            }
        }.store(in: &cancellables)
    }
    
    func addSharedMinter(address: String) {
        // TODO: Add Validator to Ensure proper address.
        
        fcl.send([
            .transaction(addSharedMinterTx),
            .args([.address(Flow.Address(hex: address))]),
            .limit(1000),
        ])
        
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case let .failure(error) = completion {
                // TODO: Error Handling
                self.preAuthz = error.localizedDescription
            }
        } receiveValue: { txId in
            // TODO: Setup Success Alert!
            print("Setup Shared Minter")
            self.preAuthz = txId
        }.store(in: &cancellables)
        
        print(self.preAuthz)
    }
    
    func getGroups() {
        self.floatGroups = []
        fcl.query {
            cadence {
                """
                  import FLOAT from 0xFLOAT
                  pub fun main(account: Address): {String: &FLOAT.Group} {
                    let floatEventCollection = getAccount(account).getCapability(FLOAT.FLOATEventsPublicPath)
                                                .borrow<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic}>()
                                                ?? panic("Could not borrow the FLOAT Events Collection from the account.")
                    let groups = floatEventCollection.getGroups()
                  
                    let answer: {String: &FLOAT.Group} = {}
                    for groupName in groups {
                      answer[groupName] = floatEventCollection.getGroup(groupName: groupName)
                    }
                  
                    return answer
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
            let floatGroups = block.fields?.value.toDictionary()
            floatGroups?.forEach({ group in
                var id = ""
                var uuid = ""
                var name = ""
                var image = ""
                var description = ""
                var groupEvents: [String] = []
                
                if let decodedGroup = try? JSONSerialization.jsonObject(with: group.value.jsonData!, options: .fragmentsAllowed) as? [String: Any],
                   let groupValue = decodedGroup["value"] as? [String: Any],
                   let groupFields = groupValue["fields"] as? NSArray {
                    groupFields.forEach { field in
                        if let jsonArray = try? JSONSerialization.data(withJSONObject: field, options: []) {
                            if let json = try? JSONSerialization.jsonObject(with: jsonArray, options: .fragmentsAllowed) as? [String: Any] {
                                let fieldName = json["name"] as? String ?? ""
                                let fieldValueField = json["value"] as! [String: Any]
                                let fieldValue = fieldValueField["value"] as? String ?? ""
                                
                                switch fieldName {
                                case "uuid":
                                    uuid = fieldValue
                                case "id":
                                    id = fieldValue
                                case "name":
                                    name = fieldValue
                                case "image":
                                    image = fieldValue
                                case "description":
                                    description = fieldValue
                                case "events":
                                    let events = fieldValueField["value"] as? NSArray ?? []
                                    events.forEach { event in
                                        if let eventArray = try? JSONSerialization.data(withJSONObject: event, options: []) {
                                            if let eventJSON = try? JSONSerialization.jsonObject(with: eventArray, options: .fragmentsAllowed) as? [String: Any],
                                               let keyJSON = eventJSON["key"] as? [String: Any],
                                               let eventID = keyJSON["value"] as? String,
                                               let valueJSON = eventJSON["value"] as? [String: Any],
                                               let eventInGroup = valueJSON["value"] as? Int {
                                                if eventInGroup == 1 {
                                                    groupEvents.append(eventID)
                                                }
                                            }
                                        }
                                    }
                                default:
                                    print("Not known value")
                                }
                            }
                        }
                    }
                }
                
                self.floatGroups.append(FloatGroup(id: id, uuid: uuid, name: name, image: image, description: description, events: groupEvents))
                   
            })
        }.store(in: &cancellables)
    }
    
    func getGroupEvents(events: [String], address: String) {
        events.forEach { event in
            fcl.query {
                cadence {
                    """
                      import FLOAT from 0xFLOAT
                      pub fun main(account: Address, eventId: UInt64): FLOATEventMetadata {
                        let floatEventCollection = getAccount(account).getCapability(FLOAT.FLOATEventsPublicPath)
                                                    .borrow<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic}>()
                                                    ?? panic("Could not borrow the FLOAT Events Collection from the account.")
                        let event = floatEventCollection.borrowPublicEventRef(eventId: eventId) ?? panic("This event does not exist in the account")
                        return FLOATEventMetadata(
                          _claimable: event.claimable,
                          _dateCreated: event.dateCreated,
                          _description: event.description,
                          _eventId: event.eventId,
                          _extraMetadata: event.getExtraMetadata(),
                          _groups: event.getGroups(),
                          _host: event.host,
                          _image: event.image,
                          _name: event.name,
                          _totalSupply: event.totalSupply,
                          _transferrable: event.transferrable,
                          _url: event.url,
                          _verifiers: event.getVerifiers()
                        )
                      }
                      pub struct FLOATEventMetadata {
                        pub let claimable: Bool
                        pub let dateCreated: UFix64
                        pub let description: String
                        pub let eventId: UInt64
                        pub let extraMetadata: {String: AnyStruct}
                        pub let groups: [String]
                        pub let host: Address
                        pub let image: String
                        pub let name: String
                        pub let totalSupply: UInt64
                        pub let transferrable: Bool
                        pub let url: String
                        pub let verifiers: {String: [{FLOAT.IVerifier}]}
                        init(
                            _claimable: Bool,
                            _dateCreated: UFix64,
                            _description: String,
                            _eventId: UInt64,
                            _extraMetadata: {String: AnyStruct},
                            _groups: [String],
                            _host: Address,
                            _image: String,
                            _name: String,
                            _totalSupply: UInt64,
                            _transferrable: Bool,
                            _url: String,
                            _verifiers: {String: [{FLOAT.IVerifier}]}
                        ) {
                            self.claimable = _claimable
                            self.dateCreated = _dateCreated
                            self.description = _description
                            self.eventId = _eventId
                            self.extraMetadata = _extraMetadata
                            self.groups = _groups
                            self.host = _host
                            self.image = _image
                            self.name = _name
                            self.transferrable = _transferrable
                            self.totalSupply = _totalSupply
                            self.url = _url
                            self.verifiers = _verifiers
                        }
                      }
                    """
                }
                
                arguments {
                    [.address(Flow.Address(hex: address)), .uint64(UInt64(event) ?? 0)]
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
                let groupEvents = block.fields?.jsonData
                if let decodedEvent = try? JSONSerialization.jsonObject(with: groupEvents!, options: .fragmentsAllowed) as? [String: Any],
                   let eventValue = decodedEvent["value"] as? [String: Any],
                   let eventFields = eventValue["fields"] as? NSArray {
                    var claimable = false
                    var dateCreated = ""
                    var description = ""
                    var eventId = ""
                    var groups: NSDictionary = [:]
                    var host = ""
                    var image = ""
                    var name = ""
                    var totalSupply = ""
                    var transferrable = false
                    var url = ""
                    
                    eventFields.forEach { field in
                        if let eventArray = try? JSONSerialization.data(withJSONObject: field, options: []) {
                            if let eventJSON = try? JSONSerialization.jsonObject(with: eventArray, options: .fragmentsAllowed) as? [String: Any],
                               let fieldName = eventJSON["name"] as? String,
                               let fieldValue = eventJSON["value"] as? [String: Any] {
                                switch fieldName {
                                case "claimable":
                                    claimable = fieldValue["value"] as! Bool
                                case "dateCreated":
                                    dateCreated = fieldValue["value"] as! String
                                case "description":
                                    description = fieldValue["value"] as! String
                                case "eventId":
                                    eventId = fieldValue["value"] as! String
                                case "groups":
                                    print("Do Nothing")
                                case "host":
                                    host = fieldValue["value"] as! String
                                case "image":
                                    image = fieldValue["value"] as! String
                                case "name":
                                    name = fieldValue["value"] as! String
                                case "totalSupply":
                                    totalSupply = fieldValue["value"] as! String
                                case "transferrable":
                                    transferrable = fieldValue["value"] as! Bool
                                case "urL":
                                    url = fieldValue["url"] as! String
                                default:
                                    print("Do Nothing")
                                }
                            }
                        }
                    }
                    
                    print(FLOATEventMetadata(claimable: claimable, dateCreated: dateCreated, description: description, eventId: eventId, host: host, image: image, name: name, totalSupply: totalSupply, transferrable: transferrable, url: url))
                }
            }.store(in: &cancellables)
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
                self.reverseLookupFIND(address: self.address)
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
