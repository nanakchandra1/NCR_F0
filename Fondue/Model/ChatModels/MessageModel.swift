//
//  MessageModel.swift
//  RCC_Firebase_Chat
//
//  Created by Harsh Vardhan Kushwaha on 16/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MessageModel : Equatable {
    let isBlock, isDeleted: Bool
    let mediaDuration, mediaURL, messageCaption, messageID: String
    let messageRoomID, messageText: String
    let messageStatus : DeliveryStatus
    let messageTimestamp: TimeInterval
    let lattitude, longitude: Double
    let receiverID, senderID, videoThumbnail: String
    let messageType : MessageType
}

// MARK: Convenience initializers

extension MessageModel {
    
    init(with json: JSON) {
        mediaDuration      = json["mediaDuration"].stringValue
        mediaURL   = json["mediaUrl"].stringValue
        messageCaption    = json["messageCaption"].stringValue
        messageID  = json["messageId"].stringValue
        messageRoomID      = json["messageRoomId"].stringValue
        let messageStatusInt = json["messageStatus"].intValue
        messageStatus = DeliveryStatus(rawValue: messageStatusInt) ?? .read
        messageText = json["messageText"].stringValue
        messageTimestamp = json["messageTimestamp"].doubleValue
        lattitude = json["lattitude"].doubleValue
        longitude = json["longitude"].doubleValue
        let messageTypeString = json["messageType"].stringValue
        messageType = MessageType(rawValue: messageTypeString) ?? .none
        receiverID = json["receiverId"].stringValue
        senderID = json["senderId"].stringValue
        videoThumbnail = json["thumbnail"].stringValue
        isBlock  = json["isBlock"].boolValue
        isDeleted  = json["isDeleted"].boolValue
    }
    
    static func ==(lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.messageID == rhs.messageID
    }
}
