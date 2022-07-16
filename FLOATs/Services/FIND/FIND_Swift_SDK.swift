import Foundation
import Combine
import FCL
import Flow
import BigInt
import CryptoKit

public class FIND_Swift_SDK {
    private var cancellables = Set<AnyCancellable>()
    
    private var profile: FINDProfile?
    private var address: String?

    public init() {
        if ((fcl.currentUser?.loggedIn) != nil) {
            address = fcl.currentUser!.addr.hex
        }
    }
    
    public func reverseLookupFIND(address: String) async -> String {
        do {
            let block = try await fcl.query {
                cadence {
                    """
                    import FIND, Profile from 0xFIND

                    pub fun main(address: Address) :  String? {
                        return FIND.reverseLookup(address)
                    }
                    """
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
