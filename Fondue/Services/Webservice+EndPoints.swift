//
//  Webservice+EndPoints.swift
//  StarterProj
//
//  Created by Gurdeep on 06/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

import Foundation


let BASE_URL = "http://52.8.169.78:7129/" // dev server
//let BASE_URL = "http://52.8.169.78:7127/" //staging server


extension WebServices {

    enum EndPoint : String {
       
        case signup = "user/signup"
        case signup_dsp = "user/signup_with_dsp"
        case login = "user/login"
        case changepassword = "user/change-password"
        case forgotpassword = "user/forgot-password"
        case varifyOTP = "user/varify-otp"
        case resetpassword = "user/reset-password"
        case managefriends
        case check_availability = "user/check_availability"
        case addPlayList = "playlist/add_playlist"
        
//        case getPlayAllList = "playlist/get_playlist"//staging serve
//
//        case getUserPlayList = "playlist/get_playlist_all"//staging serve

        case getPlayAllList = "playlist/get_playlist_all" // dev server
        
        case getUserPlayList = "playlist/get_playlist" // dev server

        case getPlayListTracks = "playlist/get_tracks"
        case logout = "user/logout"
        case verifyUser = "user/varify-user"
        case tidalLogin = "user/signup_with_tidal"
        case notifications = "user/notifications"

        
        var path : String {
            let url = BASE_URL
            return url + self.rawValue
        }
    }
}


