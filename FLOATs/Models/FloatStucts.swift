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
