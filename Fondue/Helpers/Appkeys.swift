//
//  Appkeys.swift
//  Fondue
//
//  Created by Nanak on 15/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import Foundation

struct SpotifyConstant {
    
    struct AppKeys {
        static let clientId = "07582ac35903426e9694b1f0a74dfd6f"
        static let redirectUrl = "fondue123://returnafterlogin"
        static let sessionUserDefaultsKey = "current session"
        static let userDetailUrl = "https://api.spotify.com/v1/me"
        static let subscriptionPageUrl = "https://www.spotify.com/uk/purchase/panel/?checkout=false#__main-pci-credit-card"
    }
}

typealias DeezerObjectListRequest = (_ objectList: DZRObjectList? ,_ error: Error?) -> Void


enum SessionState {
    
    case connected
    case disconnected
    
}

struct DeezerConstant {
    
    // Key saved in Keychain
    struct KeyChain {
        static let deezerTokenKey = "DeezerTokenKey"
        static let deezerExpirationDateKey = "DeezerExpirationDateKey"
        static let deezerUserIdKey = "DeezerUserIdKey"
    }
    
    struct AppKey {
        //CHANGE THE VALUE WITH YOUR APP ID
        static let appId = "271542"//"269562"
    }
    
}
