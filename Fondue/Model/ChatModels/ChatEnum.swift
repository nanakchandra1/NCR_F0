//
//  ChatEnum.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import Foundation

enum MessageType: String {
    
    case none = "none"
    case text = "text"
    case audio = "audio"
    case video = "video"
    case image = "image"
    case left = "left"
    case added = "added"
    case created = "created"
    case changed = "changed"
    case header = "header"
    case action = "action"
    case location = "location"

    var text: String {
        switch self {
        case .image:
            return "Sent an image"
        case .video:
            return "Sent a video"
        case .audio:
            return "Sent an audio"
        default:
            return ""
        }
    }
}

enum DatabaseNode {
    
    enum Root: String {
        
        case roomInfo = "room_info"
        case inbox = "inbox"
        case messages = "messages"
        case lastMessage = "lastMessage"
        case users = "users"
        case block = "block"
        case accessToken = "accessToken"
        case userBlockStatus = "users_block_status"
    }
    
    enum Rooms: String {

        case memberDelete = "memberDelete"
        case memberLeave = "memberLeave"
        case memberJoin = "memberJoin"
        case memberId = "memberId"
        case roomAdmin = "roomadmin"
        
    }
    
    enum RoomInfo: String {
        
        case lastUpdates = "chatLastUpdates"
        case lastUpdate = "chatLastUpdate"
        case isTyping = "chatRoomIsTyping"
        case roomId = "chatRoomId"
        case chatPic = "chatRoomPic"
        case chatTitle = "chatRoomTitle"
        case chatType = "chatRoomType"
        case chatRoomMembers = "chatRoomMembers"
        
    }
    
    enum Messages: String {
        
        case timestamp = "messageTimestamp"
        case messageId = "messageId"
        case message = "messageText"
        case sender = "senderId"
        case status = "messageStatus"
    }
    
    enum Users: String {
        
        case firstName = "firstName"
        case lastName = "lastName"
        case profilePic = "userImage"
        case deviceToken = "deviceToken"
        case userId = "userId"
    }
    
    enum LastMessage: String {
        case chatLastMessage = "chatLastMessage"
    }
    
}

enum Chat {
    case none
    case new
    case existing
}

enum ChatType: String {
    case none
    case single = "Single"
    case group = "Group"
}

enum DeliveryStatus: Int {
    case sent = 1
    case delivered
    case read
}

enum Message: String {
    case type = "messageType"
    case message = "messageText"
    case sender = "senderId"
    case status = "messageStatus"
    case mediaUrl = "mediaUrl"
    case thumbnail = "thumbnail"
    case caption = "messageCaption"
    case isBlock = "isBlock"
    case timestamp = "messageTimestamp"
    case messageId = "messageId"
    case duration = "mediaDuration"
    case lattitude = "lattitude"
    case longitude = "longitude"
    case roomId = "roomId"

}
