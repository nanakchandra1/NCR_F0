//
//  Inbox.swift
//  RCC_Firebase_Chat
//
//  Created by Harsh Vardhan Kushwaha on 16/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class Inbox : Hashable {
    var hashValue: Int
    var roomId : String
    var unreadCount : Int = 0
    var chatRoom : ChatRoom?
    var chatMember : ChatMember?
    var lastMessage : MessageModel?
    
    init(with json: JSON) {
        roomId                  = json["roomId"].stringValue
        unreadCount                  = json["unreadCount"].intValue
        hashValue               = roomId.hashValue
    }
    
    init(with roomId: String) {
        self.roomId                  = roomId
        hashValue               = roomId.hashValue
    }
    
    static func ==(lhs: Inbox, rhs: Inbox) -> Bool {
        return lhs.roomId == rhs.roomId
    }

}

struct ChatRoom {
    
    var chatRoomId,chatRoomTitle,chatRoomPic : String
    var chatRoomType : ChatType
    let lastUpdate              : Double
    var lastUpdates             : [UserUpdates]

    init(with json: JSON) {
        chatRoomId                  = json["chatRoomId"].stringValue
        chatRoomTitle               = json["chatRoomTitle"].stringValue
        let typeString              = json["chatRoomType"].stringValue
        chatRoomType                = ChatType(rawValue: typeString.capitalized) ?? .none
        chatRoomPic                 = json["chatRoomPic"].stringValue
        lastUpdate              = json["chatLastUpdate"].doubleValue
        lastUpdates             = UserUpdates.models(from: json["chatLastUpdate"].dictionaryValue)

    }
    
}

class UserUpdates {
    
    let id          : String
    let updatedAt   : Double
    
    init(id: String, updatedAt: Double) {
        self.id          = id
        self.updatedAt   = updatedAt
    }
    
    static func models(from dictionary: [String: JSON]) -> [UserUpdates] {
        var updates = [UserUpdates]()
        for (key, value) in dictionary {
            let update = UserUpdates(id: key, updatedAt: value.doubleValue)
            updates.append(update)
        }
        return updates
    }
}
