import Foundation
import Combine
import FCL
import Flow
import BigInt
import CryptoKit

public class FIND_Swift_SDK {
    public static let shared = FIND_Swift_SDK()
    private var address: String?
    private var cancellables = Set<AnyCancellable>()
    public var profile: FINDProfile?

    public init() {
        if ((fcl.currentUser?.loggedIn) != nil) {
            address = fcl.currentUser!.addr.hex
        }
    }
    
    public func checkFindProfile() async {
        if address != nil {
            let profile = await reverseLookupProfile(address: address!)
            print(profile)
        }
    }
    
    public func reverseLookupProfile(address: String) async -> String {
        do {
            let block = try await fcl.query {
                cadence {
                    FindScripts.reverseLookupProfile.rawValue
                }
                
                arguments {
                    [.address(Flow.Address(hex: address))]
                }
            }.decode(FINDProfile.self)
            await MainActor.run {
                self.profile = block
            }
            
            return ""
        } catch {
            print(error)
            return ""
        }
    }
    
    public func reverseLookupFIND(address: String) async -> String {
        do {
            let block = try await fcl.query {
                cadence {
                    FindScripts.reverseLookupFIND.rawValue
                }
            }.decode()
            await MainActor.run {
                print(block)
            }
            
            return ""
        } catch {
            print(error)
            return ""
        }
    }
}
