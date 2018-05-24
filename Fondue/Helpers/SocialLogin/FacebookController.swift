//
//  FacebookController.swift
//  FacebookLogin
//
//  Created by Appinventiv on 10/08/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Social
import Accounts
//import SwiftyJSON

class FacebookController {
    
    // MARK:- VARIABLES
    //==================
    static let shared = FacebookController()
    var facebookAccount: ACAccount?
    
    private init() {}
    
    // MARK:- FACEBOOK LOGIN
    //=========================
    
    func loginWithFacebook(fromViewController viewController: UIViewController, completion: @escaping FBSDKLoginManagerRequestTokenHandler) {
        
        if let _ = FBSDKAccessToken.current() {
            
            facebookLogout()
            
        }
        
        let permissions = ["user_about_me", "user_birthday" , "email", "user_photos", "user_events", "user_friends", "user_videos", "public_profile"]
        
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.native
        
        login.logIn(withReadPermissions: permissions, from: viewController, handler: {
            result, error in
            
            if let res = result,res.isCancelled {
                completion(nil,error)
            }else{
                completion(result,error)
            }
            
        })
    }
    
    // MARK:- FACEBOOK LOGIN WITH SHARE PERMISSIONS
    //================================================
    func loginWithSharePermission(fromViewController viewController: UIViewController, completion: @escaping FBSDKLoginManagerRequestTokenHandler) {
        
        if let current = FBSDKAccessToken.current(), current.hasGranted("publish_actions") {
            
            let result = FBSDKLoginManagerLoginResult(token: FBSDKAccessToken.current(), isCancelled: false, grantedPermissions: nil, declinedPermissions: nil)
            
            completion(result,nil)
        } else {
            
            let login = FBSDKLoginManager()
            login.loginBehavior = FBSDKLoginBehavior.native
            
            FBSDKLoginManager().logIn(withPublishPermissions: ["publish_actions"], from: viewController, handler: { (result, error) in
                
                if let res = result,res.isCancelled {
                    completion(nil,error)
                }else{
                    completion(result,error)
                }
            })
        }
    }
    
    
    // MARK:- GET FACEBOOK USER INFO
    //================================
    
    func getFacebookUserInfo(fromViewController viewController: UIViewController,
                             success: @escaping ((FacebookModel) -> Void),
                             failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithFacebook(fromViewController: viewController, completion: { (result, error) in
            
            if error == nil,let _ = result?.token {
                self.getInfo(success: { (result) in
                    success(result)
                }, failure: { (e) in
                    failure(e)
                })
            }
        })
    }
    
    private func getInfo(success: @escaping ((FacebookModel) -> Void),
                         failure: @escaping ((Error?) -> Void)){
        
        // FOR MORE PARAMETERS:- https://developers.facebook.com/docs/graph-api/reference/user
        
        let params = ["fields": "email, name, gender, first_name, last_name, birthday, cover, currency, devices, education, hometown, is_verified, link, locale, location, relationship_status, website, work, picture.type(large)"]
        
        if let request = FBSDKGraphRequest(graphPath: "me", parameters: params) {
            request.start(completionHandler: {
                connection, result, error in
                
                if let result = result as? [String : Any] {
                    success(FacebookModel(withDictionary: result))
                } else {
                    failure(error)
                }
            })
        }
    }
    
    
    
    // MARK:- GET IMAGE FROM FACEBOOK
    //=================================
    
    func getProfilePicFromFacebook(userId:String,_ completionBlock:@escaping (UIImage?)->Void){
        
        guard let url = URL(string:"https://graph.facebook.com/\(userId)/picture?type=large") else {
            return
        }
        
        let request = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, url: url, parameters: nil)
        
        request?.account = self.facebookAccount
        
        request?.perform(handler: { (responseData: Data?, _, error: Error?) in
            if let data = responseData{
                let userImage=UIImage(data: data)
                completionBlock(userImage)
            }
        })
    }
    
    
    // MARK:- SHARE WITH FACEBOOK
    //=============================
    func shareMessageOnFacebook(withViewController vc : UIViewController,
                                _ message: String,
                                success: @escaping (([String:Any]) -> Void),
                                failure: @escaping ((Error?) -> Void)) {
        
            self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
                
                if error == nil,let token = result?.token,let tokenString = token.tokenString {
                    let param: [String:Any] = ["message" : message, "access_token" : tokenString]
                    
                    FBSDKGraphRequest(graphPath: "me/feed", parameters: param, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                        if let error = error {
                            failure(error)
                        } else {
                            if let result = result as? [String : Any] {
                                success(result)
                            }else{
                                let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                                failure(err)
                            }
                        }
                    })
                }else{
                    failure(error)
                }
            })
    }
    
    func shareImageWithCaptionOnFacebook(withViewController vc : UIViewController,
                                         _ imageUrl: String,
                                         _ captionText: String,
                                         success: @escaping (([String:Any]) -> Void),
                                         failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
            
            if error == nil,let token = result?.token,let tokenString = token.tokenString {
                let param: [String:Any] = [ "url" : imageUrl, "caption" : captionText, "access_token" : tokenString]
                
                FBSDKGraphRequest(graphPath: "me/photos", parameters: param, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        failure(error)
                    } else {
                        if let result = result as? [String : Any] {
                            success(result)
                        }else{
                            let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                            failure(err)
                        }
                    }
                })
            }else{
                failure(error)
            }
        })
    }

    func shareVideoWithCaptionOnFacebook(withViewController vc : UIViewController,
                                         _ videoUrl: String,
                                         _ captionText: String,
                                         success: @escaping (([String:Any]) -> Void),
                                         failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
            
            if error == nil,let token = result?.token,let tokenString = token.tokenString {
                let param: [String:Any] = [ "url" : videoUrl, "caption" : captionText, "access_token" : tokenString]
                
                FBSDKGraphRequest(graphPath: "me/videos", parameters: param, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        failure(error)
                    } else {
                        if let result = result as? [String : Any] {
                            success(result)
                        }else{
                            let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                            failure(err)
                        }
                    }
                })
            }else{
                failure(error)
            }
        })
    }

    
    // MARK:- FACEBOOK FRIENDS
    //==========================
    func fetchFacebookFriendsUsingThisAPP(withViewController vc: UIViewController,success: @escaping (([String:Any]) -> Void),
                              failure: @escaping ((Error?) -> Void)){
        
            self.loginWithFacebook(fromViewController: vc, completion: { (result, err) in
                
                self.fetchFriends(success: { (result) in
                    
                    success(result)
                    
                }, failure: { (err) in
                    
                    failure(err)
                    
                })

            })
    }
    
    private func fetchFriends(success: @escaping (([String:Any]) -> Void),
                              failure: @escaping ((Error?) -> Void)){
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "email, name, gender, first_name, last_name, birthday, cover, currency, devices, education, hometown, is_verified, link, locale, location, relationship_status, website, work, picture.type(large)"])
        
        request.start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            
            if let result = result as? [String:Any] {
                success(result)
            } else {
                failure(error)
            }
        }

    }
    
    func fetchFacebookFriendsNotUsingThisAPP(viewController : UIViewController, success: @escaping (([String:Any]) -> Void),
                                          failure: @escaping ((Error?) -> Void)){
        
        FBSDKLoginManager().logIn(withPublishPermissions: ["taggable_friends"], from: viewController, handler: { (result, error) in
            
            if let res = result,res.isCancelled {
                failure(error)
            }else{
                if error == nil {
                    let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "name"])
                    
                    request.start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
                        
                        if let result = result as? [String:Any] {
                            success(result)
                        } else {
                            failure(error)
                        }
                    }
                }else{
                    failure(error)
                }
            }
        })
    }

    // MARK:- FACEBOOK LOGOUT
    //=========================
    func facebookLogout(){
        FBSDKAccessToken.current()
        FBSDKLoginManager().logOut()
        let cooki  : HTTPCookieStorage! = HTTPCookieStorage.shared
        if let strorage = HTTPCookieStorage.shared.cookies{
            for cookie in strorage{
                cooki.deleteCookie(cookie)
            }
        }
    }
    
}

// MARK: FACEBOOK MODEL
//=======================
struct FacebookModel {
    var dictionary : [String:Any]!
    var id = ""
    var email = ""
    var name = ""
    var first_name = ""
    var last_name = ""
    var currency = ""
    var link = ""
    var gender :Gender?
    var verified = ""
    var cover: URL?
    var picture: URL?
    var is_verified : Bool
    
    //    init(withJSON json: JSON) {
    //        self.id = json["id"].stringValue
    //        self.name = json["name"].stringValue
    //        self.first_name = json["first_name"].stringValue
    //        self.currency = json["currency"]["user_currency"].stringValue
    //        self.email = json["email"].stringValue
    //        self.gender = json["gender"].stringValue
    //        self.picture = URL(string: json["picture"]["data"]["url"].stringValue)
    //        self.cover = URL(string: json["cover"]["source"].stringValue)
    //        self.link = json["link"].stringValue
    //        self.last_name = json["last_name"].stringValue
    //        self.is_verified = json["is_verified"].stringValue
    //    }
    
    init(withDictionary dict: [String:Any]) {
        
        print(dict)
        self.dictionary = dict
        
        self.id = "\(dict["id"] ?? "")"
        self.name = "\(dict["name"] ?? "")"
        self.first_name = "\(dict["first_name"] ?? "")"
        self.email = "\(dict["email"] ?? "")"
       // self.gender = "\(dict["gender"] ?? "")"
        
        if let gender = dict["gender"] as? String, !gender.isEmpty{
            let g = gender.capitalized
            self.gender = Gender(rawValue: g)
        }

        if let currencyDict = dict["currency"] as? [String:Any] {
            
            self.currency = "\(currencyDict["user_currency"] ?? "")"
            
        }
        if let picture = dict["picture"] as? [String:Any],let data = picture["data"] as? [String:Any] {
            
            self.picture = URL(string: "\(data["url"] ?? "")")
            
        }
        if let cover = dict["cover"] as? [String:Any] {
            
            self.picture = URL(string: "\(cover["source"] ?? "")")
            
        }
        self.link = "\(dict["link"] ?? "")"
        self.last_name = "\(dict["last_name"] ?? "")"
        self.is_verified = "\(dict["is_verified"] ?? "")" == "0" ? false : true
        
    }
    
}

