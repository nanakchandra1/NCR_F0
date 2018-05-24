//
//  Webservices.swift
//  StarterProj
//
//  Created by Gurdeep on 16/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON

internal typealias successWithCodeClosure = (_ errorMessage: String, _ data: JSON , _ code : Int) -> Void

internal typealias successClosure = (_ success : Bool, _ errorMessage: String, _ data: JSON) -> Void
internal typealias successArrayClosure = (_ success : Bool, _ errorMessage: String, _ data: [JSON]) -> Void

enum NetworkResponse {
    
    case value(JSON)
    case error(Error)
}

enum WebServices { }

extension NSError {

    convenience init(localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

extension WebServices {

    static func signUpWithDSPsAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .signup_dsp, parameters: parameters, loader: true, success: { (json) in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })

            
        }) { (e) in
            failure(e)

        }
        
    }
    
    static func signUpAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .signup, parameters: parameters, loader: true, success: { (json) in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
            
            
        }) { (e) in
            failure(e)

        }
    }
    
    static func tidalSignUpAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successWithCodeClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .tidalLogin, parameters: parameters, loader: true, success: { (json) in
            
            let message = json["message"].stringValue
            let code = json["statusCode"].intValue
            let result = json["result"]

            webServiceSuccess(message, result, code)
            

        }) { (e) in
            failure(e)
            
        }
    }



    static func loginAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .login, parameters: parameters, loader: true, success: { (json) -> () in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }

    static func verifyOTP(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .varifyOTP, parameters: parameters,  loader: true, success: { (json) -> () in
            
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }

    static func verify_User_OTP(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .verifyUser, parameters: parameters,  loader: true, success: { (json) -> () in
            
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }

    static func checkAvailability(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .check_availability, parameters: parameters, loader: true, success: { (json) -> () in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }

    
    static func changePasswordAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        
        AppNetworking.POST(endPoint: .changepassword, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    static func forgotPasswordAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        
        AppNetworking.POST(endPoint: .forgotpassword, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    
    static func resetPasswordAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        
        AppNetworking.POST(endPoint: .resetpassword, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    
    static func logOutAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        
        AppNetworking.POST(endPoint: .logout, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }

    
    static func addPlaylistAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        
        AppNetworking.POST(endPoint: .addPlayList, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSession(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }

    
    static func getPlaylistAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successArrayClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .getPlayAllList, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSessionWithArrayData(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
            AppNetworking.removeLoader()

        })
    }
    
    static func getUserPlaylistAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successArrayClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .getUserPlayList, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSessionWithArrayData(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
            AppNetworking.removeLoader()
            
        })
    }

    
    static func getPlaylistTracksAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successArrayClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .getPlayListTracks, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSessionWithArrayData(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    
    static func getNotificationsAPI(parameters : JSONDictionary, webServiceSuccess : @escaping successArrayClosure, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .notifications, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            checkSessionWithArrayData(with: json, completionBlock: { (isSuccess, msg, data) in
                webServiceSuccess(isSuccess,msg,data)
            })
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }

//    static func getSpotifyPlaylistAPI(url : String, webServiceSuccess : @escaping ((_ totalNumberOfItems:Int, _ playlist: [JSON]) -> Void), failure : @escaping FailureResponse) {
//
//        // Configure Parameters and Headers
//
//        AppNetworking.GETWithStringURLWithHeader(endPoint: url, success: { (json : JSON) in
//
//            print_debug(json)
//            let totalNumberOfItems = json["total"].intValue
//            let playList = json["data"].arrayValue
//            webServiceSuccess(totalNumberOfItems, playList)
//
//        }) { (e : Error) in
//            print_debug(e.localizedDescription)
//        }
//    }
//
//
//    static func getSpotifyPlaylistTracksAPI(url : String, webServiceSuccess : @escaping ((_ totalNumberOfItems:Int, _ playlist: [JSON]) -> Void), failure : @escaping FailureResponse) {
//
//        // Configure Parameters and Headers
//
//        AppNetworking.GETWithStringURLWithHeader(endPoint: url, success: { (json : JSON) in
//
//            print_debug(json)
//            let totalNumberOfItems = json["total"].intValue
//            let playList = json["data"].arrayValue
//            webServiceSuccess(totalNumberOfItems, playList)
//
//        }) { (e : Error) in
//            print_debug(e.localizedDescription)
//        }
//    }

    
    static func getDeezerPlaylistAPI(url : String, webServiceSuccess : @escaping ((_ totalNumberOfItems:Int, _ playlist: [JSON]) -> Void), failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        
        AppNetworking.GETWithStringURLWithHeader(endPoint: url, success: { (json : JSON) in
            
            print_debug(json)
            let totalNumberOfItems = json["total"].intValue
            let playList = json["data"].arrayValue
            webServiceSuccess(totalNumberOfItems, playList)
            
        }) { (e : Error) in
            print_debug(e.localizedDescription)
        }
    }

    
    static func getDeezerTracklistAPI(url : String, webServiceSuccess : @escaping ((_ totalNumberOfItems:Int, _ playlist: [JSON]) -> Void), failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        
        AppNetworking.GETWithStringURLWithHeader(endPoint: url, success: { (json : JSON) in
            
            print_debug(json)
            let totalNumberOfItems = json["total"].intValue
            let playList = json["data"].arrayValue
            webServiceSuccess(totalNumberOfItems, playList)
            
        }) { (e : Error) in
            print_debug(e.localizedDescription)
        }
    }

    
    static func getTidalPlaylistAPI(url : String, webServiceSuccess : @escaping ((_ limit: Int,_ totalNumberOfItems:Int, _ playlist: [JSON]) -> Void), failure : @escaping FailureResponse) {
        
        AppNetworking.GETWithStringURLWithHeader(endPoint: url, success: { (json : JSON) in
            
            print_debug(json)
            let totalNumberOfItems = json["totalNumberOfItems"].intValue
            let limit = json["limit"].intValue
            let playList = json["items"].arrayValue
            webServiceSuccess(limit, totalNumberOfItems, playList)
            
        }) { (e : Error) in
            print_debug(e.localizedDescription)
        }
    }

    static func getSpotifyUserDetaiAPI(url : String, header : [String: String], webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        AppNetworking.GETWithStringURL(endPoint: url,headers :header , success: { (json : JSON) in
            
            print_debug(json)
            webServiceSuccess(true, "msg", json)
            
        }) { (e : Error) in
            print_debug(e.localizedDescription)
        }
    }
    
    static func getSpotifyPlaylistAPI(url : String, header : [String: String], webServiceSuccess : @escaping (( _ playlist: [JSON]) -> Void)) {
        
        AppNetworking.GETWithStringURL(endPoint: url,headers :header , success: { (json : JSON) in
            
            print_debug(json)
            let items = json["items"].arrayValue
            webServiceSuccess(items)
            
        }) { (e : Error) in
            print_debug(e.localizedDescription)
        }
    }


    static func getDeezerUserDetaiAPI(url : String, params : JSONDictionary, webServiceSuccess : @escaping successClosure, failure : @escaping FailureResponse) {
        
        AppNetworking.GETWithStringURL(endPoint: url, parameters: params,success: { (json : JSON) in
            
            print_debug(json)
            webServiceSuccess(true, "msg", json)
            
        }) { (e : Error) in
            print_debug(e.localizedDescription)
        }
    }

}

//MARK:- Error Codes
//==================
struct error_codes {
    
    static let success = 200
    static let noData = 201
    static let userNotFound = 254
    static let userBlocked = 244
    static let userSubscribe = 276
}


func checkSession(with response : JSON , completionBlock: successClosure){
    
   // hideLoader()
    let message = response["message"].stringValue
    let code = response["statusCode"].intValue
    
    if code == error_codes.success{

        let result = response["result"]
        
        completionBlock(true, message, result)
        
    }else if code == error_codes.noData{
        
        //postLogoutNavigate()
        
    }else if code == error_codes.userNotFound{
        completionBlock(false, message, [[:]])
        logOut()
    }else if code == error_codes.userBlocked{
        logOut()
        completionBlock(false, message, [[:]])
    }else{
        completionBlock(false, message, [:])
    }
}


func checkSessionWithArrayData(with response : JSON , completionBlock: successArrayClosure){
    
    //hideLoader()
    
    let message = response["message"].stringValue
    let code = response["statusCode"].intValue
    
    if code == error_codes.success{

        let result = response["result"].arrayValue
        
        completionBlock(true, message, result)
        
    }else if code == error_codes.noData{

        //postLogoutNavigate()
        
    }else if code == error_codes.userNotFound{
        logOut()
        completionBlock(false, message, [[:]])
    }else if code == error_codes.userBlocked{
        logOut()
        completionBlock(false, message, [[:]])
    }else{
        completionBlock(false, message, [[:]])
    }
}




func logOut(){
    AppUserDefaults.removeAllValues()
    clearTokenAndExpirationDate()
    NavigationManager.gotoLoginOption()
}
