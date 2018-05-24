//
//  ChatMember.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import SwiftyJSON
import Foundation

struct ChatMember: Hashable {
    
    var hashValue: Int
    let deviceToken, email, firstName, lastName: String
    let selected: Bool
    let userID, userImage: String
    
    var jsonValue : JSON {
        
        let dict : [String : Any] = ["deviceToken" : deviceToken,
                    "email" : email,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "selected" : selected,
                    "userID" : userID,
                    "userImage" : userImage]
        
        return JSON(dict)
        
    }
    
}

extension ChatMember {
    
    init(with json: JSON) {
        userID      = json["userId"].stringValue
        firstName   = json["firstName"].string ?? json["first_name"].stringValue
        lastName    = json["lastName"].string ?? json["last_name"].stringValue
        userImage  = json["userImage"].string ?? json["profile_image"].stringValue
        email      = json["email"].stringValue
        deviceToken = json["deviceToken"].stringValue
        selected  = json["selected"].boolValue
        hashValue = userID.hashValue
    }
    
    static func ==(left:ChatMember, right:ChatMember) -> Bool {
        return left.userID == right.userID
    }
    
    static func models(from jsonArray: [JSON]) -> [ChatMember] {
        var models: [ChatMember] = []
        for json in jsonArray {
            let member = ChatMember(with: json)
            models.append(member)
        }
        return models
    }
}

