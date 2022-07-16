//
//  FloatGroups.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/14/22.
//

import Foundation

struct FloatGroup: Decodable, Hashable {
    let id: String
    let uuid: String
    let name: String
    let image: String
    let description: String
    let events: [String]
}

struct FLOATEventMetadata {
    let claimable: Bool
    let dateCreated: String
    let description: String
    let eventId: String
    let host: String
    let image: String
    let name: String
    let totalSupply: String
    let transferrable: Bool
    let url: String
}
