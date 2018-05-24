//
//  Manager.swift
//  SpotifyDemo
//
//  Created by Nanak on 22/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

typealias SpotifyLoginResult = ((Bool) -> ())


class SpotifyManager: NSObject {
    
    static let shared = SpotifyManager()

    let sharedAuth : SPTAuth = SPTAuth.defaultInstance()

    var loginResult: SpotifyLoginResult?
    var loginUrl: URL?
    var session:SPTSession!
    
    var player: SPTAudioStreamingController?
    
    var userID: String!
    var useName: String!
    var userDetail : JSON!
    

    
    func startSpotify(){
    
        self.sharedAuth.redirectURL = URL(string: SpotifyConstant.AppKeys.redirectUrl)
        self.sharedAuth.sessionUserDefaultsKey = SpotifyConstant.AppKeys.sessionUserDefaultsKey

        self.sharedAuth.clientID = SpotifyConstant.AppKeys.clientId
        self.sharedAuth.redirectURL = URL(string: SpotifyConstant.AppKeys.redirectUrl)
        self.sharedAuth.requestedScopes = [SPTAuthStreamingScope,SPTAuthPlaylistModifyPrivateScope,SPTAuthPlaylistModifyPrivateScope,SPTAuthPlaylistModifyPublicScope,SPTAuthUserReadEmailScope,SPTAuthUserReadPrivateScope]
        self.loginUrl = self.sharedAuth.spotifyWebAuthenticationURL()
        
        let obj = WebViewVC.instantiate(fromAppStoryboard: .PreLogin)
        obj.url = self.loginUrl
        obj.modalTransitionStyle = .crossDissolve
        obj.modalPresentationStyle = .overCurrentContext
        sharedAppDelegate.parentNavigationController.present(obj, animated: true, completion: nil)

    }
    
    

    
    
    
    func spotifySessionDidLogin(success: Bool) {
        
        self.updateAfterFirstLogin ()
        
    }

    
    @objc func updateAfterFirstLogin () {
        
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            
            guard let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession else {
                
                return
            }
            
            self.session = firstTimeSession
            
            self.checkSpotifySubscription()

        }
    }
    
    
    func checkSpotifySubscription(){
        
        self.getSpotifyUserDetai(completion: { (product,session ) in
            
            if product == "open" || product == "free" {

                let urlString = SpotifyConstant.AppKeys.subscriptionPageUrl

                NavigationManager.showPopUP(title: StringConstants.NOT_A_PREMIUM.localized, message: StringConstants.GOTO_SPOTIFY_SUBSCRIPTION.localized ,url: urlString)

            } else if product == "premium" {

                NotificationCenter.default.post(name: .getAccessTokenNotification, object: nil)

            } else {
                // Handle Product type not known
            }

        }) { (err) -> (Void) in
            
        }
    }
    
    
    func getSpotifyUserDetai( completion : @escaping ((_ status : String , _ session : SPTSession) -> Void) , failure : @escaping FailureResponse) {
        
        guard let session = self.session else {return}
        
        let url = SpotifyConstant.AppKeys.userDetailUrl
        
        let accesToken = session.accessToken!
        
        var header = [String : String]()
        
        header["Authorization"] = "Bearer \(String(describing: accesToken))"
        
        WebServices.getSpotifyUserDetaiAPI(url: url , header: header, webServiceSuccess: { (success, msg, json) in
            
            self.userDetail = json
            let product = json["product"].stringValue
            self.useName = json["display_name"].stringValue
            self.userID = json["id"].stringValue
            
            completion(product, session)
            
        }) { (err) -> (Void) in
            failure(err)
        }
    }
}

// get All Playlist From Spotify

extension SpotifyManager{
    

}
    

