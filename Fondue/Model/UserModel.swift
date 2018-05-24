//
//  UserModel.swift
//  Onboarding
//
//  Created by Gurdeep Singh on 08/07/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SwiftyJSON

enum Gender : String {
    
    case Male = "Male", Female = "Female" ,Other = "Other"
    
    var indexOfGender : Int {
        
        switch self {
            
        case .Male :
            return 0
        case .Female :
            return 1
        case .Other :
            return 2
            
        }
    }
    
    var stringValueOfGender : String {
        
        switch self {
            
        case .Male :
            return StringConstants.Male.localized
        case .Female :
            return StringConstants.Female.localized
        case .Other :
            return StringConstants.Other.localized
            
        }
    }
    
    static let  allOption : [Gender] = [.Male,.Female,.Other]
    
}


class User {
    
    var first_name : String = ""
    var middle_name : String = ""
    var last_name : String = ""
    var displayName : String = ""
    var email : String = ""
    var gender : Gender?
    var dob : Date?
    var age : String = ""
    var phone : String = ""
    var password : String = ""
    var confirm_password : String = ""
    var city : String = ""
    var country_code : String = ""
    var region : String = ""
    var longitude : String = ""
    var latitude : String = ""
    var postal_code : String = ""
    var biography : String = ""
    var imageUrl : String = ""
    
    var tidal_session_id : String = ""
    var tidal_user_id : String = ""
    var tidal_countryCode : String = ""
    var image : UIImage?
    var responseString : String?
    var user_id : String?
    var token : String?
    var otp_varified = 0
    var importedList : Bool = false

    init(){}
    
    init(dictionary : [String:Any]) {
        
        self.populate(dictionary)
        
    }
    
    init(json : JSON) {
        
        let dictionary = json.dictionaryObject ?? [String:AnyObject]()
        
        self.populate(dictionary)
        
    }
    
    fileprivate func populate(_ dictionary : JSONDictionary) {
        
        let json = JSON(dictionary)
        
        //password
        self.displayName = json["name"].stringValue
        self.first_name = json["firstName"].stringValue
        self.last_name = json["lastName"].stringValue
        self.token = json["token"].stringValue
        self.imageUrl = json["user_image"].stringValue
        self.email = json["email"].stringValue
        self.password = json["password"].stringValue
        self.confirm_password = json["confirm_password"].stringValue
        self.user_id = json["user_id"].string ?? json["_id"].stringValue
        self.tidal_user_id = json["tidal_user_id"].stringValue
        self.tidal_session_id = json["tidal_session_id"].stringValue
        self.tidal_countryCode = json["tidal_countryCode"].stringValue
        self.otp_varified = json["status"].intValue
        self.importedList = json["importedList"].boolValue
        
        if let gender = json["gender"].string,!gender.isEmpty{
            let g = gender.uppercased()
            self.gender = Gender(rawValue: g)
        }
        
        if let dobUNIXtimeStamp = json["dob"].double{
            let dob = Date(timeIntervalSince1970: dobUNIXtimeStamp)
            self.dob = dob
        }
    }
    
    func dictionary() -> [String:Any] {
        
        var details = [String:Any]()
        details["first_name"] = first_name
        details["last_name"] = last_name
        details["email"] = email
        if let gender = self.gender {
            details["gender"] = gender.rawValue
        }
        details["age"] = age
        details["dob"] = dob?.toString(dateFormat: "MM/dd/yyyy")
        details["password"] = password
        
        return details
        
    }
    
    var checkValidity : CredentialsValidity {
        
        if image == nil{
            return .invalid(StringConstants.Select_profile_image.localized)
        }
        
        if !first_name.isEmpty {
            
            if first_name.count<3 {
                
                return .invalid(StringConstants.First_Name_Invalid_Length.localized)
                
            }
            
            if first_name.checkIfInvalid(ValidityExression.name) {
                
                return .invalid(StringConstants.Invalid_First_Name.localized)
                
            }
        } else {
            
            return .invalid(StringConstants.Enter_First_Name.localized)
            
        }
        
        
        if !last_name.isEmpty {
            
//            if last_name.checkIfInvalid(ValidityExression.name) {
//
//                return .invalid(StringConstants.Invalid_Last_Name.localized)
//            }
            
            if last_name.count<3 {
                return .invalid(StringConstants.Last_Name_Invalid_Length.localized)
            }
        } else {
            return .invalid(StringConstants.Enter_Last_Name.localized)
            
        }
        
        
        if email.isEmpty {
            
            return .invalid(StringConstants.Enter_Email.localized)
            
        } else {
            if email.checkIfInvalid(.email) {
                
                return .invalid(StringConstants.Invalid_Email.localized)
            }
        }
        
        if !self.password.isEmpty {
            
            if password.checkIfInvalid(ValidityExression.password) {
                
                return .invalid(StringConstants.Invalid_Password.localized)
            }
        } else {
            
            return .invalid(StringConstants.Enter_Password.localized)
        }

        if gender == nil{
            return .invalid(StringConstants.SELECT_GENDER.localized)
        }
        
        if age.isEmpty {
            
            return .invalid(StringConstants.ENTER_D_O_B.localized)

        }
        
        return .valid

    }
        
}

extension User: Swift.CustomStringConvertible, Swift.CustomDebugStringConvertible {
    
    var description: String {
        
        var str = "<User : \(Unmanaged.passUnretained(self).toOpaque())> {"
        
       // str.append("username : \(username), ")
        str.append("emailId : \(email)")
        
        str.append("}")
        return str
    }
    
    var debugDescription: String {
        return description
    }
}
