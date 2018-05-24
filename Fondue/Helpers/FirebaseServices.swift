//
//  FirebaseServices.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import Firebase
import SwiftyJSON
import AVFoundation
import FirebaseDatabase
import FirebaseStorage


let DatabaseReference = Database.database().reference()

var msgCount:[String:UInt] = [:]

var _inboxObserver: [String:UInt] = [:]
var _msgObserver: [String:UInt] = [:]

class FirebaseHelper {
    
    deinit {
        print_debug("FirebaseHelper deinit")
    }

    private static var curUserId: String {
        return sharedAppDelegate.currentuser.userID
    }

    private static var curUser: ChatMember {
        return sharedAppDelegate.currentuser
    }

    /*********************
     Creating the new user
     **********************/
    
    
    
    static func createUser(email:String,password:String,completion: @escaping (Bool)->()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            

            if error == nil {
                
                if let user = user {
                    print_debug("FIRUSER: \(user.uid)")
                    createUsersNode()

                    //authenticate(withEmail: email, password: password, completion: completion)
                }

            } else if let error = error {
                
                print_debug(error.localizedDescription)
                completion(false)

            } else {
                
                print_debug("Something went wrong. Please try again later.")
                completion(false)
            }
        }
        
    }
    
    /*********************
     Authenticating the user
     **********************/
    static func authenticate(withEmail email: String, password: String, completion: @escaping (Bool)->()){
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil{
                
                if let user = user{
                    
                    print("FIRUSER: \(user.uid)")
                    completion(true)
                }
            }else if let error = error{
                
                print( error.localizedDescription)
                completion(false)
            }else{
                
                print( "Something went wrong. Please try again later.")
                completion(false)
            }
            
        }
    }
    
    /*********************
     Createing the new user
     **********************/
    
    static func createUsersNode() {
        
        let user: JSONDictionary = [DatabaseNode.Users.firstName.rawValue: self.curUser.firstName,
                                     DatabaseNode.Users.lastName.rawValue: self.curUser.lastName,
                                     DatabaseNode.Users.profilePic.rawValue: self.curUser.userImage,
                                     DatabaseNode.Users.deviceToken.rawValue: DeviceDetail.deviceToken,
                                     DatabaseNode.Users.userId.rawValue: self.curUser.userID]
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(self.curUser.userID).setValue(user) { (error, _) in
            if let err = error {
                print_debug(err.localizedDescription)
            }
        }
        //self.updateDeviceToken(deviceToken, self.curUser.userID)
    }

    /*********************
     Updating the device token
     **********************/
    static func updateDeviceToken(_ deviceToken: String, _ userID: String) {
        
        guard !deviceToken.isEmpty else { return }
        guard !userID.isEmpty else { return }
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userID).updateChildValues([DatabaseNode.Users.deviceToken.rawValue:deviceToken])
    }
    
    /*********************
     Deleting the user
     **********************/
    /*
    static func deleteUser(_ userID: String){
        
        guard !userID.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userID).child(DatabaseNode.Users.isDelete.rawValue).setValue(true)
    }
    */
    
    /*********************
     returning the messageid
     **********************/
    static func getMessageId(forRoom roomId: String) -> String {
        
        let messageId = DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId).childByAutoId().key
        
        return messageId
    }
    
    /*********************
     returning the roomid
     **********************/
    static func getRoomId() -> String {
        
        let roomId = DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).childByAutoId().key
        
        return roomId
    }
    
    
    /*********************
     Checking for exixtence of room
     **********************/
    static func checkRoomExists(_ postId: String, _ userID: String ,_ completion: @escaping ( _ exists: Bool, _ roomId: String?)->()){
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? [String:Any], let roomId = value[postId] as? String{
                
                completion(true,roomId)
                
            }else{
                
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userID).observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let value = snap.value as? [String:Any], let roomId = value[postId] as? String{
                        
                        completion(true,roomId)
                        
                    }else{
                        
                        completion(false, nil)
                    }
                })
            }
        })
    }
    
    /*********************
     getting the message dictinary from message object
     **********************/
    private static func getMessageDict(_ chatMessage: MessageModel) -> JSONDictionary {
        
        var message = JSONDictionary()
        
        message[Message.type.rawValue] = chatMessage.messageType.rawValue
        message[Message.message.rawValue] = chatMessage.messageText
        message[Message.sender.rawValue] = chatMessage.senderID
        message[Message.status.rawValue] = chatMessage.messageStatus.rawValue
        message[Message.mediaUrl.rawValue] = chatMessage.mediaURL
        message[Message.thumbnail.rawValue] = chatMessage.videoThumbnail
        message[Message.caption.rawValue] = chatMessage.messageCaption
        message[Message.isBlock.rawValue] = chatMessage.isBlock
        message[Message.timestamp.rawValue] = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = chatMessage.messageID
        message[Message.duration.rawValue] = chatMessage.mediaDuration
        message[Message.roomId.rawValue] = chatMessage.messageRoomID

        return message
    }
    
    /*********************
     Sending the message in room
     **********************/
    static func sendMessage(_ chatMessage: MessageModel, _ roomId: String, _ node: DatabaseNode.Root) {
        
        guard !roomId.isEmpty else { return }
        let message: JSONDictionary = getMessageDict(chatMessage)

        switch node {
            
        case .messages:
            DatabaseReference.child(node.rawValue).child(roomId).child(chatMessage.messageID).setValue(message)
            
        case .lastMessage:
            DatabaseReference.child(node.rawValue).child(roomId).setValue(message)
            
        default:
            return
        }
    }

    static func createMessageInfo(messageId: String, users: [UserUpdates]) {
        guard !messageId.isEmpty else { return }
        for user in users {
            let status: DeliveryStatus
            if user.id == curUserId {
                status = .read
            } else {
                status = .sent
            }
            DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(messageId).child(user.id).setValue(status.rawValue)
        }
    }
    
    /*********************
     Setting the group left message
     **********************/
    static func setGroupLeftLastMessage(_ chatMessage: MessageModel, _ roomId: String) {
        
        guard !roomId.isEmpty else { return }
        
        let message: [String:Any] = getMessageDict(chatMessage)
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue).setValue(message)
    }
    
    /*********************
     Setting the last user update
     **********************/
    static func setUserLastUpdates(_ roomId: String, _ userID: String) {
        
        guard !roomId.isEmpty else { return }
        guard !userID.isEmpty else { return }
        
        /*userID: Current user id*/
        
        let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(userID).setValue(timeStamp)
        
    }
    /*********************
     Setting the last update for room
     **********************/
    static func setLastUpdates( roomId: String,  userID: String) {
        
        guard !roomId.isEmpty else { return }
        guard !userID.isEmpty else { return }
        
        /*userID: Current user id*/
        
        let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdate.rawValue).setValue(timeStamp)
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(userID).setValue(timeStamp)
        
    }
    /*********************
     starting the new chat
     **********************/
    static func startNewChat(_ groupMembers: [ChatMember], info: ChatRoom) -> String {
        let chatType: ChatType
        if groupMembers.count == 1 {
            chatType = .single
        } else {
            chatType = .group
        }
        return createRoomInfo(groupMembers, chatType, info: info)
    }
    
    /*********************
     Creating the room info
     **********************/
    private static func createRoomInfo(_ groupMembers: [ChatMember], _ chatType: ChatType, info: ChatRoom) -> String {
        
        let roomId = getRoomId()
        let firebaseTimeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        let roomInfoReference = DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId)

        roomInfoReference.child(DatabaseNode.RoomInfo.chatPic.rawValue).setValue(info.chatRoomPic)
        roomInfoReference.child(DatabaseNode.RoomInfo.chatTitle.rawValue).setValue(info.chatRoomTitle)
        roomInfoReference.child(DatabaseNode.RoomInfo.chatType.rawValue).setValue(chatType.rawValue)
        roomInfoReference.child(DatabaseNode.RoomInfo.lastUpdate.rawValue).setValue(firebaseTimeStamp)
        roomInfoReference.child(DatabaseNode.RoomInfo.roomId.rawValue).setValue(roomId)
        
        for eachContact in groupMembers {
            roomInfoReference.child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(eachContact.userID).setValue(0)
        }
        
        createRoom(roomId, groupMembers, chatType)
        return roomId
    }
    
    /*********************
     Creating the room for group chat
     **********************/
    private static func createRoom(_ roomId: String, _ groupMembers: [ChatMember],_  chatType: ChatType) {
        
        guard !roomId.isEmpty else { return }
        guard groupMembers.count > 0 else { print("Empty group members");return }
        
        let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        var unusedChatColors: [String] = []

        var randomColor: String {
            if unusedChatColors.isEmpty {
//                unusedChatColors = chatColors
            }
            let randomIndex = Int(arc4random_uniform(UInt32(unusedChatColors.count)))
            let color = unusedChatColors[randomIndex]
            unusedChatColors.remove(at: randomIndex)
            return color
        }
        
        for participant in groupMembers {
            
            var room = JSONDictionary()
            room[DatabaseNode.Rooms.memberId.rawValue] = participant.userID
            room[DatabaseNode.Rooms.memberJoin.rawValue] = timeStamp
            room[DatabaseNode.Rooms.memberDelete.rawValue] = timeStamp
            room[DatabaseNode.Rooms.memberLeave.rawValue] = 0
            room[DatabaseNode.Rooms.roomAdmin.rawValue] = 0
            
            DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.chatRoomMembers.rawValue).child(participant.userID).setValue(room)
        }
        
        var room = JSONDictionary()
        room[DatabaseNode.Rooms.memberId.rawValue] = self.curUserId
        room[DatabaseNode.Rooms.memberJoin.rawValue] = timeStamp
        room[DatabaseNode.Rooms.memberDelete.rawValue] = timeStamp
        room[DatabaseNode.Rooms.memberLeave.rawValue] = 0
        room[DatabaseNode.Rooms.roomAdmin.rawValue] = 1
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.chatRoomMembers.rawValue).child(self.curUserId).setValue(room)
        createInbox(roomId, groupMembers, chatType)
    }
    
    /*********************
     Creating the inbox for group chat
     **********************/
    static func createInbox(_ roomId: String, _ groupMembers: [ChatMember],_  chatType: ChatType) {
        
        guard !roomId.isEmpty else { return }
        
        if chatType == .single {
            
            guard !groupMembers.isEmpty else {
                
                print_debug("FirebaseHelper CreateInbox :\(groupMembers.count)")
                return
            }
            
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(groupMembers[0].userID).child(self.curUserId).setValue(roomId)
            
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).child(groupMembers[0].userID).setValue(roomId)
            
        } else {
            
            for eachContact in groupMembers {
                
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(eachContact.userID).child(roomId).setValue(roomId)
            }
            
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).child(roomId).setValue(roomId)
        }
    }
    
    /*********************
     Creating the inbox for post
     **********************/
    static func createInboxForPost(_ key: String, _ roomId: String, _ groupMembers: [ChatMember],_  chatType: ChatType) {
        
        guard !roomId.isEmpty else { return }
        
        guard groupMembers.count > 0 else {
            
            print("FirebaseHelper CreateInbox :\(groupMembers.count)")
            return
        }
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(groupMembers[0].userID).child(key).setValue(roomId)
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).child(key).setValue(roomId)
        
    }
    
    /*********************
     Getting the old messages by passing the roomid and delete time
     **********************/
    static  func getOldMessages(_ roomId: String, _ deleteStamp: Int) {
        
        let firebaseTimeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(self.curUserId).setValue(firebaseTimeStamp)
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.chatRoomMembers.rawValue).child(self.curUserId).child(DatabaseNode.Rooms.memberDelete.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value{
                
                let deletestamp = JSON(value).intValue
                //getLast25Messages(roomId, deletestamp: deletestamp)
            }
        })
    }
    
    
    /*********************
     Getting the room info info by passing the roomid
     **********************/
    static func getRoomInfo(_ roomId: String, completion: @escaping (_ roomInfo: ChatRoom)->()) {
        
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value {
                
                print_debug(value)
                let roomInfo = ChatRoom(with: JSON(value))
                completion(roomInfo)
            }
        })
    }
    
    /*********************
     Getting the chat member info by passing the userid
     **********************/
    static func getChatMemberInfo(_ userID: String, _ completion: @escaping (_ member:ChatMember?)->()) {
        
        guard !userID.isEmpty else { return }
        
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value {
                
                let member = ChatMember(with: JSON(value))
                completion(member)
                
            } else {
                completion(nil)
            }
        })
    }

    static func getExistingMembers(roomId: String, completion: @escaping ([ChatMember]) -> Void) {
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).observeSingleEvent(of: .value) { (snapshot) in

            guard let value = snapshot.value else {
                return
            }
            let json = JSON(value)
            let members = ChatMember.models(from: json.arrayValue)
            completion(members)
        }
    }
    
    /*********************
     Adding the user in group chat by passing the roomid
     **********************/
    static func addNewMembers(newMembers: [ChatMember], to roomId: String ) {

        guard !roomId.isEmpty else { return }

        getExistingMembers(roomId: roomId) { members in

            let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)

            for eachMember in newMembers {

                DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(eachMember.userID).setValue(0)

                var room = JSONDictionary()
                room[DatabaseNode.Rooms.memberId.rawValue] = eachMember.userID
                room[DatabaseNode.Rooms.memberJoin.rawValue] = timeStamp
                room[DatabaseNode.Rooms.memberDelete.rawValue] = timeStamp
                room[DatabaseNode.Rooms.memberLeave.rawValue] = 0

                DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.chatRoomMembers.rawValue).child(eachMember.userID).setValue(room)
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(eachMember.userID).child(roomId).setValue(roomId)
                DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(eachMember.userID).removeValue()
                DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(eachMember.userID).removeValue()

                //            sendTextMessage(eachMember.userID, type: .added, {_,_ in
                //                print_Debug("sent")
                //            })
            }
            //createInbox(roomId, groupMembers, chatType)
        }
    }

    /*********************
     getting the user detail by passing the userid
     **********************/
    static func getUserDetail(_ userID: String, completion: @escaping (_ chatMember: ChatMember?)->()) {
        
        guard !userID.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let value = snapshot.value as? JSONDictionary else {
                return
            }
            print_debug(value)
            let memberJSON = JSON(value)
            let member = ChatMember(with: memberJSON)
            completion(member)
        })
    }
    /*********************
     getting the messages as pagination
     **********************/
    static func getPaginatedData(_ roomId: String, _ lastKey: String, _ deleteStamp: Double, _ completion: @escaping (_ messages: [MessageModel]) -> ()) {
        
        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId).queryOrderedByKey().queryEnding(atValue: lastKey).queryLimited(toLast: 25).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let value = snapshot.value as? JSONDictionary else {
                return
            }
            
            print_debug(value)
            var messages: [MessageModel] = []

            for (_, val) in value {

                let json = JSON(val)
                let msg = MessageModel(with: json)

                guard msg.messageID != lastKey && msg.messageTimestamp > deleteStamp else {
                    continue
                }

                if msg.senderID != self.curUserId && msg.isBlock {
                    print_debug("Blocked")

                } else {
                    messages.append(msg)
                }
            }
            completion(messages)
        })
    }
    /*********************
     Blocking the user by passing the userid and roomid
     **********************/
    static func blockUser(_ userID: String, _ roomId: String,_ message: MessageModel) {
        
        var lastMessage = JSONDictionary()
        
        lastMessage[Message.messageId.rawValue] = message.messageID
        lastMessage[Message.message.rawValue] = message.messageText
        lastMessage[Message.timestamp.rawValue] = message.messageTimestamp
        lastMessage[Message.sender.rawValue] = message.senderID
        lastMessage[Message.status.rawValue] = message.messageStatus.rawValue
        lastMessage[Message.type.rawValue] = message.messageType
        lastMessage[Message.isBlock.rawValue] = message.isBlock
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue).setValue(lastMessage)
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.isTyping.rawValue).child(self.curUserId).setValue(false)
        
        DatabaseReference.child(DatabaseNode.Root.block.rawValue).child(self.curUserId).child(userID).setValue(ServerValue.timestamp()) //(Date().timeIntervalSince1970 * 1000)
        
    }
    
    /*********************
     Checking for user exist or not
     **********************/
    static func checkUserExists(_ userId: String, _ curUserId: String ,_ completion: @escaping ( _ exists: Bool, _ roomId: String?)->()){
        
        guard !userId.isEmpty else { return }
        guard !curUserId.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(curUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? [String:Any], let roomId = value[userId] as? String{
                
                completion(true,roomId)
                
            }else{
                
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let value = snap.value as? [String:Any], let roomId = value[curUserId] as? String{
                        
                        completion(true,roomId)
                        
                    }else{
                        
                        completion(false, nil)
                    }
                })
            }
        })
    }

    
    /*********************
     Blocking the user from anywhere in app by passing the userid
     **********************/
    static func blockUserFromAnywhere(_ userID: String){
        
        self.checkUserExists(userID, self.curUserId) { (exists, roomId) in
            
            if exists{
                
                self.getLastMessage(userID, roomId!, completion: { (lastMessage) in
                    
                    if let lastMessage = lastMessage{
                        self.blockUser(userID, roomId!, lastMessage)
                    }
                })
                
            }else{
                DatabaseReference.child(DatabaseNode.Root.block.rawValue).child(self.curUserId).child(userID).setValue(ServerValue.timestamp()) //(Date().timeIntervalSince1970 * 1000)
            }
        }
    }
    
    /*********************
     Blocking the user by passing the userid and roomid
     **********************/
    static func blockUser(_ userID: String, _ roomId: String, inbox message: Inbox){
        
        var lastMessage: [String:Any] = [:]

        /*
        lastMessage[Message.messageId.rawValue] = message.messageId
        lastMessage[Message.message.rawValue] = message.message
        lastMessage[Message.timestamp.rawValue] = message.timeStamp
        lastMessage[Message.sender.rawValue] = message.senderId
        lastMessage[Message.status.rawValue] = message.status.rawValue
        */
        lastMessage[Message.type.rawValue] = message.lastMessage?.messageType ?? ""
        lastMessage[Message.isBlock.rawValue] = 0
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue).setValue(lastMessage)
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.isTyping.rawValue).child(self.curUserId).setValue(false)
        
        DatabaseReference.child(DatabaseNode.Root.block.rawValue).child(self.curUserId).child(userID).setValue(ServerValue.timestamp()) //(Date().timeIntervalSince1970 * 1000)
        
    }
    
    /*********************
     Getting the last message for user by passing the userid and roomid
     **********************/
    static func getLastMessage(_ userID: String, _ roomId: String, completion: @escaping (_ lastMessage: MessageModel?)->()){
        
        guard !roomId.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let value = snapshot.value as? [String:Any]{
                
                if snapshot.hasChild(self.curUserId){
                    
                    if let userLastMessageDict = value[self.curUserId] as? [String:Any]{
                        
                        let lastMsg = JSON(userLastMessageDict)
                        
                        let chatLastMsg = MessageModel(with: lastMsg["chatLastMessage"])
                        
                        completion(chatLastMsg)
                    }
                    
                }else{
                    
                    let chatLastMsg = MessageModel(with: JSON(value)["chatLastMessage"])
                    completion(chatLastMsg)
                }
            }
        })
    }

    /*********************
     setting the message info status
     **********************/
    static func setMessageInfoStatus(_ message: MessageModel, status: DeliveryStatus) {
        let userID = sharedAppDelegate.currentuser.userID

        guard message.messageStatus != .read,
            message.messageStatus != status,
            !message.messageID.isEmpty,
            !message.isBlock,
            !userID.isEmpty else { return }

        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(message.messageID).child(userID).setValue(status.rawValue)
    }
    
    /*********************
     setting the message read status
     **********************/
    static func setMessageStatus(_ message: MessageModel, roomId: String, status: DeliveryStatus) {

        let userID = sharedAppDelegate.currentuser.userID

        guard message.messageStatus != .read,
            message.messageStatus != status,
            !message.messageID.isEmpty,
            !roomId.isEmpty,
            !message.isBlock,
            !userID.isEmpty else {
                return
        }

        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId).child(message.messageID).child(DatabaseNode.Messages.status.rawValue).setValue(status.rawValue)

        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(DatabaseNode.Messages.status.rawValue).setValue(status.rawValue)
    }
    
    /*********************
     logout the user session
     **********************/
    static func logOut() {
        
        do{
            try Auth.auth().signOut()
        } catch let error {
            print_debug(error)
        }
    }
    /*********************
     updating the password for user
     **********************/
    static func updateUserPassword(password: String, completion: @escaping (Bool)->()) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            
            if error == nil{
                completion(true)
            } else {
                completion(false)
            }
        })
        
        
        
    }
    
    /*********************
     sending the password on email
     **********************/
    static func resendPassword(email: String,  completion: @escaping (Bool)->()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
//Get Unread Messages count
//=======================================
extension FirebaseHelper {

    /*********************
     setting observer for getting the unread message count for inbox
     **********************/
    static func getUnreadMessageCount() {
        
        _inboxObserver["un_inbox"] = DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).observe(.childAdded, with: { (snapshot) in
            
            if let value = snapshot.value as? String{
                
                
                msgCount = [:]
                self.getDeleteStamp(value)
            }
            
        })
        
        _inboxObserver["un_inbox_del"] = DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).observe(.childRemoved, with: { (snapshot) in
            
            if let value = snapshot.value as? String{
                
                msgCount = [:]
                self.getDeleteStamp(value)
                
            }
            
        })
    }
    
    
    /*********************
     Getting the delete time stamp
     **********************/
    private static func getDeleteStamp(_ roomId: String) {
        
        guard !roomId.isEmpty, !DatabaseNode.Root.roomInfo.rawValue.isEmpty,!self.curUserId.isEmpty,!DatabaseNode.Rooms.memberDelete.rawValue.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.chatRoomMembers.rawValue).child(self.curUserId).child(DatabaseNode.Rooms.memberDelete.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value{
                
                let deletestamp = JSON(value).intValue
                self.getLeaveStamp(roomId, deleteStamp: deletestamp)
            }
        })
        
    }
    /*********************
     Getting the leave time stamp
     **********************/
    private static func getLeaveStamp(_ roomId: String, deleteStamp: Int) {
        
        guard !roomId.isEmpty,!DatabaseNode.Root.roomInfo.rawValue.isEmpty,!self.curUserId.isEmpty,!DatabaseNode.Rooms.memberLeave.rawValue.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.chatRoomMembers.rawValue).child(self.curUserId).child(DatabaseNode.Rooms.memberLeave.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value {
                
                let leavestamp = JSON(value).intValue
                //self.getCount(roomId, deleteStamp: deleteStamp,leaveStamp: leavestamp)
            }
        })
        
    }
    
    static func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler : @escaping (_ session : AVAssetExportSession) -> Void){
        
        do {
            try FileManager.default.removeItem(at: outputURL as URL)
        }
        catch {
            
        }
        let asset = AVURLAsset(url: inputURL as URL, options: nil)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        
        exportSession?.outputURL = outputURL as URL
        
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.exportAsynchronously(completionHandler: {
            
            handler(exportSession!)
        })
    }

    
    static func uploadTOFireBaseVideo(url: URL,
                                success : @escaping (String) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name
        
        let dispatchgroup = DispatchGroup()
        
        dispatchgroup.enter()
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in
            
            ur = session.outputURL!
            dispatchgroup.leave()
            
        }
        dispatchgroup.wait()
        
        let data = NSData(contentsOf: ur as URL)
        
        do {
            
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
            
        } catch {
            
            print(error)
        }
        
        let storageRef = Storage.storage().reference().child("Videos").child(name)
        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if let error = error {
                        failure(error)
                    }else{
                        let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                        success(strPic)
                    }
            })
        }

        
    }

}

extension UIImage {
    

    //MARK: - Upload image to firebase
    func uploadImageToFireBase(success : @escaping (String) -> Void,
                     failure : @escaping (Error) -> Void){
        
        let imageName:String = String("\(Int(Date().timeIntervalSince1970)).png")
        
        let storageRef = Storage.storage().reference().child("Images").child(imageName)
        if let uploadData = UIImagePNGRepresentation(self){
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if let error = error {
                        failure(error)
                    }else{
                        let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                        success(strPic)
                    }
            })
        }
    }
}

