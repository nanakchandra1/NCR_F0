//
//  UserProfileController.swift
//  Onboarding
//
//  Created by Appinventiv on 18/09/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserProfileController {
    
    static let shared = UserProfileController()
    
    private init() {
        
    }
    
//    func getProfileData(success : @escaping UserControllerSuccess,failure : @escaping FailureResponse){
//
//        WebServices.profileAPI(success: { (json) in
//
//            print_debug(json)
//
//            let code = json["error_code"].intValue
//            
//            if code == error_codes.success{
//
//                let modelededData = User(json: json)
//                success(modelededData)
//
//            }else{
//                let msg = json["error_string"].stringValue
//                let error = NSError.init(localizedDescription: msg)
//                failure(error)
//            }
//
//        }) { (e) in
//
//            failure(e)
//        }
//
//    }
    
}
