//
//  Scripts.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation

enum FloatScripts: String {
    case isSetup =
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
    case getGroups =
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
