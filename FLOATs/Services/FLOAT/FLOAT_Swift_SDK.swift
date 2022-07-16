//
//  FLOAT_Swift_SDK.swift
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation
import Combine
import FCL
import Flow
import BigInt
import CryptoKit

public let float = FLOAT_Swift_SDK.shared

public class FLOAT_Swift_SDK {
    public static let shared = FLOAT_Swift_SDK()
    private var cancellables = Set<AnyCancellable>()
    private var address: String?
    
    public var floatSetup = false

    public init() {
        if ((fcl.currentUser?.loggedIn) != nil) {
            address = fcl.currentUser!.addr.hex
        }
    }
    
    public func setupFloatAccount() async {
        do {
            let txId = try await fcl.send([
                .transaction(FloatTransactions.setupAccountTx.rawValue),
                .limit(1000),
            ]).hex
            await MainActor.run {
                self.floatSetup = true
                
                // TODO: Transaction Monitoring
                print(txId)
            }
        } catch {
            // TODO: Error Handling
            print(error)
        }
    }
    
    private func floatIsSetup() async {
        if ((fcl.currentUser?.loggedIn) != nil) {
            do {
                let block = try await fcl.query {
                    cadence {
                        FloatScripts.isSetup.rawValue
                    }
                    
                    arguments {
                        [.address(Flow.Address(hex: self.address ?? ""))]
                    }
                    
                    gasLimit {
                        1000
                    }
                }.decode()
                await MainActor.run {
                    print(block)
                }
            } catch {
                // TODO: Error Handling
                print(error)
            }
            
            fcl.query {
                cadence {
                    FloatScripts.isSetup.rawValue
                }
                
                arguments {
                    [.address(Flow.Address(hex: self.address ?? ""))]
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
}
