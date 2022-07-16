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
}
