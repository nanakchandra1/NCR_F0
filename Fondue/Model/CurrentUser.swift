//
//  CurrentUser.swift
//  Fondue
//
//  Created by Nanak on 17/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import Foundation


class CurrentUser {
    
    static var displayName : String? {
        
        return AppUserDefaults.value(forKey: .displayName).stringValue
    }
    
    static var firstName : String? {
        return AppUserDefaults.value(forKey: .displayName).stringValue
    }
    
    static var LastName : String? {
        return AppUserDefaults.value(forKey: .lastName).stringValue
    }
    
    
    static var gender : Gender? {
        
        if let gender = AppUserDefaults.value(forKey: .gender).string {
            let g = gender.uppercased()
            let gen = Gender(rawValue: g)
            return gen
        }else{
            return nil
        }
    }
    
    static var email : String? {
        return AppUserDefaults.value(forKey: .email).stringValue
    }
    
    static var userImage : String? {
        
        return AppUserDefaults.value(forKey: .userImage).string
    }
    
    static var isPlayListImported : Bool {
        
        return AppUserDefaults.value(forKey: .isPlaylistImported).boolValue
    }

    static var age : String? {
        return AppUserDefaults.value(forKey: .age).stringValue
    }
    static var dob : String? {
        return AppUserDefaults.value(forKey: .dob).string
    }
    static var user_id : String? {
        return AppUserDefaults.value(forKey: .userId).string
    }
    
    static var tidal_session_id : String? {
        return AppUserDefaults.value(forKey: .tidal_session_id).string
    }
    static var tidal_user_id : String? {
        return AppUserDefaults.value(forKey: .tidal_user_id).string
    }

    static var tidal_countryCode : String? {
        return AppUserDefaults.value(forKey: .tidal_countryCode).string
    }

    static var accessToken : String? {
        return AppUserDefaults.value(forKey: .Accesstoken).string
    }

}
