//
//  Enums.swift
//  SpotifyDemo
//
//  Created by Nanak on 22/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

enum ResultLogin {
    
    case success
    case logout
    case error(error: Error?)
    
}

enum SignupOptionState{
    case login
    case signUp

}

enum SignupOption {
    
    case email
    case DSPs
    case facebook
    
}


enum OtpState {
    case forgotPass
    case newSignup
}


enum SelectedDSPs {
    case Spotify
    case Deezer
    case Tidel
    case AppleMusic

}


enum DSPSState{
    case signUp
    case impoprt
    case none
}


