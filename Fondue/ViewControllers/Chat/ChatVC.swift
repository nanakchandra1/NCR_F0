//
//  ChatVC.swift
//  Fondue
//
//  Created by Nanak on 19/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON
import SwifterSwift


class ChatVC: UIViewController {

    //MARK:- PROPERTIES
    //=================
    var  chatRoomInfo = ChatRoom(with: [:])
    var chatMembers = [ChatMember]()
    var senderId: String?
    
    private var chatMessages: [MessageModel] = []
    var chat: Chat = .new
    fileprivate var isMemberRemoved = false
    fileprivate lazy var refreshControl = UIRefreshControl()

    
    //MARK:- IBOutlets
    //=================

    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var chatInputView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backBtnTapp(_ sender: UIButton) {
        
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
    }
    
    @IBAction func sendBtnTap(_ sender: UIButton) {
        
        switch chat {
        case .new:
            createChat()
        case .existing, .none:
            break
        }
        
        guard let chatText = inputTextView.text,
            !chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let chatMessage = ChatHelper.composeTextMessage(chatText, chatRoomInfo.chatRoomId, false) else {
                return
        }
        
        sendMessage(chatMessage)
        setInbox()
        clearTextView()

    }
    
}


//MARK:- Private Functions
//MARK:- ==========================

extension ChatVC{
    
    private func initialSetUp(){
        
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.inputTextView.delegate = self
        self.chatTableView.estimatedRowHeight = 100
        print_debug(self.senderId)
        self.chatTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if chat != .existing {
            
            self.navigationTitle.text = chatRoomInfo.chatRoomTitle
//            self.chatMembers.append(sharedAppDelegate.currentuser)
            if chatMembers.count == 1 {
                
                chatRoomInfo.chatRoomType = .single
                
                checkIfChatRoomExists(for: chatMembers[0])
                
            } else {
                
                chat = .new
                
                chatRoomInfo.chatRoomType = .group
                
                sendGroupCreationMessage()
            }
            
        } else {
            
            chat = .existing
            
            setupChat()
            
        }

    }
    
    private func setupChat() {
        observeRoomInfo()
        observerChatMessages()
        getOldMessages()
    }

    
    
    private func checkIfChatRoomExists(for member: ChatMember) {
        
        let friendId = member.userID
        
        senderId = friendId
        
        guard !friendId.isEmpty else {
            return
        }
        
        let userId = sharedAppDelegate.currentuser.userID
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(friendId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongSelf = self else {
                return
            }
            
            if let roomId = snapshot.value as? String {
                strongSelf.chat = .existing
                strongSelf.chatRoomInfo.chatRoomId = roomId
                strongSelf.setupChat()
                
            } else {
                
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(friendId).child(userId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let roomId = snapshot.value as? String {
                        strongSelf.chat = .existing
                        strongSelf.chatRoomInfo.chatRoomId = roomId
                        strongSelf.setupChat()
                        
                    } else {
                        strongSelf.chat = .new
                        strongSelf.getSenderDetails()
                    }
                }
            }
        }
    }
    
    @objc func getOldMessages() {
        
        guard let oldestMessage = chatMessages.first else {
            return
        }
        let roomId = chatRoomInfo.chatRoomId
        let lastKey = oldestMessage.messageID
        
        FirebaseHelper.getPaginatedData(roomId, lastKey, 0, { [weak self] (messages) in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshControl.endRefreshing()
            
            if messages.isEmpty || messages.count < 25 {
                strongSelf.refreshControl.removeFromSuperview()
            }
            
            strongSelf.chatMessages.append(contentsOf: messages)
            //strongSelf.chatMessages.removeDuplicates()
            
            strongSelf.chatMessages.sort(by: { (msg1, msg2) -> Bool in
                return msg1.messageTimestamp < msg2.messageTimestamp
            })
            
            DispatchQueue.main.async {
                strongSelf.chatTableView.reloadData()
            }
        })
    }
    
    private func observeRoomInfo() {
        
        
        FirebaseHelper.getRoomInfo(chatRoomInfo.chatRoomId) { [weak self] roomInfo in
            
            guard let strongSelf = self else {
                
                return
            }
            
            var roomId = strongSelf.chatRoomInfo.chatRoomId
            
            strongSelf.chatRoomInfo = roomInfo
            
            strongSelf.chatRoomInfo.chatRoomId = roomId
            
            switch strongSelf.chatRoomInfo.chatRoomType {
                
            case .single:
                
                strongSelf.getSenderDetails()
                
            case .group:
                
                strongSelf.navigationItem.title = roomInfo.chatRoomTitle
                
            case .none:
                break
            }
        }
    }
    
    private func observerChatMessages() {
        
        guard !chatRoomInfo.chatRoomId.isEmpty else {
            return
        }
        
        let userId = sharedAppDelegate.currentuser.userID
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(chatRoomInfo.chatRoomId).child(userId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            
            let json = JSON(value)
            
            let memberJoin = json[DatabaseNode.Rooms.memberJoin.rawValue].doubleValue
            let memberLeave = json[DatabaseNode.Rooms.memberLeave.rawValue].doubleValue
            let chatDelete = json[DatabaseNode.Rooms.memberDelete.rawValue].doubleValue
            
            strongSelf.isMemberRemoved = (memberJoin < memberLeave)
            strongSelf.observeMessageAfterDeleteEvent(at: chatDelete)
        }
    }
    
    private func sendGroupCreationMessage() {
        
        switch chat {
        case .new:
            createChat()
        case .existing, .none:
            break
        }
        
        let name: String
        if sharedAppDelegate.currentuser.lastName.isEmpty {
            name = sharedAppDelegate.currentuser.firstName
        } else {
            name = "\(sharedAppDelegate.currentuser.firstName) \(sharedAppDelegate.currentuser.lastName)"
        }
        
        if let chatMessage = ChatHelper.composeHeaderMessage(message: "\(name) created group \(chatRoomInfo.chatRoomTitle)", roomId: chatRoomInfo.chatRoomId) {
            sendMessage(chatMessage)
            setInbox()
        }
    }
    
    fileprivate func sendMessage(_ message: MessageModel) {
        
        FirebaseHelper.sendMessage(message, chatRoomInfo.chatRoomId, .messages)
        FirebaseHelper.sendMessage(message, chatRoomInfo.chatRoomId, .lastMessage)
        FirebaseHelper.setLastUpdates(roomId: chatRoomInfo.chatRoomId, userID: sharedAppDelegate.currentuser.userID)
        
        if chatMembers.isEmpty {
            
            let userUpdates = chatRoomInfo.lastUpdates
            FirebaseHelper.createMessageInfo(messageId: message.messageID, users: userUpdates)
            
        } else {
            
            var userUpdates = [UserUpdates]()
            for member in chatMembers {
                let update = UserUpdates(id: member.userID, updatedAt: 0)
                userUpdates.append(update)
            }
            FirebaseHelper.createMessageInfo(messageId: message.messageID, users: userUpdates)
        }
    }
    
    private func setInbox() {
        
        let roomId = chatRoomInfo.chatRoomId
        
        switch chatRoomInfo.chatRoomType {
            
        case .none:
            
            break
            
        case .single:
            
            if let friendId = senderId {
                
                let userId = sharedAppDelegate.currentuser.userID
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(friendId).setValue(roomId)
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(friendId).child(userId).setValue(roomId)
            }
            
        case .group:
            
            for userUpdate in chatRoomInfo.lastUpdates {
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userUpdate.id).child(roomId).setValue(roomId)
            }
        }
    }
    
    
    private func createChat() {
        chatRoomInfo.chatRoomId = FirebaseHelper.startNewChat(chatMembers, info: chatRoomInfo)
        chat = .existing
        setupChat()
    }
    
    private func observeMessageAfterDeleteEvent(at value: TimeInterval) {
        
        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(chatRoomInfo.chatRoomId).queryOrdered(byChild: DatabaseNode.Messages.timestamp.rawValue).queryStarting(atValue: value).queryLimited(toLast: 25).observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            
            print_debug(value)
            
            let json = JSON(value)
            let msg = MessageModel(with: json)
            
            FirebaseHelper.setMessageInfoStatus(msg, status: .read)
            strongSelf.observeMessageStatus(msg, of: strongSelf.chatRoomInfo.chatRoomId)
            
            let indexPathToInsert = IndexPath(row: strongSelf.chatMessages.count, section: 0)
            strongSelf.chatMessages.append(msg)
            strongSelf.chatTableView.insertRows(at: [indexPathToInsert], with: .fade)
            
            NSObject.cancelPreviousPerformRequests(withTarget: strongSelf)
            strongSelf.perform(#selector(strongSelf.scrollToBottom), with: nil, afterDelay: 0.2)
        })
    }
    
    private func observeMessageStatus(_ message: MessageModel, of roomId: String) {
        
        guard !message.messageID.isEmpty,
            !roomId.isEmpty else {
                return
        }
        
        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(message.messageID).observe(.value) { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let statusDict = snapshot.value as? JSONDictionary else {
                    return
            }
            
            let sentCount = statusDict.count
            var deliveredCount = 0
            var readCount = 0
            
            for (_, value) in statusDict {
                
                guard let intValue = value as? Int,
                    let status = DeliveryStatus(rawValue: intValue) else {
                        continue
                }
                
                switch status {
                case .sent:
                    break
                case .delivered:
                    deliveredCount += 1
                case .read:
                    readCount += 1
                }
            }
            
            if readCount >= sentCount {
                strongSelf.refreshMessage(message)
                FirebaseHelper.setMessageStatus(message, roomId: roomId, status: .read)
            } else if deliveredCount >= sentCount {
                strongSelf.refreshMessage(message)
                FirebaseHelper.setMessageStatus(message, roomId: roomId, status: .delivered)
            }
        }
    }
    
    private func refreshMessage(_ message: MessageModel) {
        if let index = chatMessages.index(of: message) {
            let indexPath = IndexPath(row: index, section: 0)
            chatTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    
    @objc private func scrollToBottom() {
        let messageCount = chatMessages.count
        guard messageCount > 0 else {
            return
        }
        let lastMessageIndexPath = IndexPath(row: (messageCount - 1), section: 0)
        chatTableView.scrollToRow(at: lastMessageIndexPath, at: .bottom, animated: true)
    }

    func getSenderDetails() {
        
        guard let id = senderId,
            !id.isEmpty else {
                return
        }
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(id).observe(.value) { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            
            var name = ""
            let json = JSON(value)
            let imgString = json[DatabaseNode.Users.profilePic.rawValue].string
            
            if let firstName = json[DatabaseNode.Users.firstName.rawValue].string {
                name = firstName
            }
            
            if let lastName = json[DatabaseNode.Users.lastName.rawValue].string {
                name.append(" \(lastName)")
            }
            
            strongSelf.navigationItem.title = name
        }
    }
}

//MARK:- TextView Delegate
//========================
extension ChatVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard let text = textView.text else {
            return
        }
        
        if text.isEmpty || text.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            
            self.sendButton.isEnabled = false
            self.resetFrames()
            return
            
        }else {
            
            self.sendButton.isEnabled = true
            
        }
        
        let height = text.heightOfText(self.inputTextView.bounds.width - 10, font: UIFont.systemFont(ofSize: 15)) + 10
        
        if height > 40 && height < 100 {
            
            self.inputViewHeightConstraint.constant = height + 20
            
            UIView.animate(withDuration: 0.3) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    fileprivate func resetFrames() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.inputViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    fileprivate func clearTextView(){
        self.inputTextView.text?.removeAll()
        self.sendButton.isEnabled = false
        self.resetFrames()
        self.inputTextView.resignFirstResponder()
    }
    
}


//MARK:- UITableview delegate and datasource methods
//MARK:- ==========================

extension ChatVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatMessages[indexPath.row]
        
        var isMyMessage = true
        
        if message.senderID == sharedAppDelegate.currentuser.userID {
            isMyMessage = true
        }else{
            isMyMessage = false
        }

        return dequeTextCell(indexPath, isMyMessage)
    }
    
    
    private func dequeTextCell(_ indexPath : IndexPath,_ isMyMessage : Bool) -> UITableViewCell {
        
        let message = chatMessages[indexPath.row]
        
        if isMyMessage {
            guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderCell else{
                fatalError("SentChatMessageCell not found on line \(#line) of function \(#function) in file \(#file)")
            }
            cell.populate(with: message)
            return cell
        }else{
            guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as? ReceiverCell else{
                fatalError("ReceivedChatMessageCell not found on line \(#line) of function \(#function) in file \(#file)")
            }
            cell.populate(with: message, chatType: chatRoomInfo.chatRoomType)
            return cell
            
        }
        
    }
    
}

//MARK:- Cell Classess
//MARK:- ==========================

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func populate(with message: MessageModel) {
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(message.senderID).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            
            let json = JSON(value)
            let member = ChatMember(with: json)
            
//            strongSelf.senderNameLbl.text = nil //"\(member.firstName) \(member.lastName)"
//            strongSelf.senderImageView.imageFromURl(member.userImage, placeHolderImage: #imageLiteral(resourceName: "user"))
            
        }
        
        msgLbl.text = message.messageText
        
        let messageDate = Date(timeIntervalSince1970: message.messageTimestamp/1000)
        dateLbl.text = messageDate.timeAgoSince
    }
    
    
}

class ReceiverCell: UITableViewCell {
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var slopeView: UIView!
    @IBOutlet weak var msgLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.slopeView.addSlope(withColor: UIColor(red: 255/255, green: 102/255, blue: 0/255, alpha: 1), ofWidth: 20, ofHeight: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func populate(with message: MessageModel, chatType: ChatType){
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(message.senderID).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            
            let json = JSON(value)
            let member = ChatMember(with: json)
            
//            if chatType != .single {
//                strongSelf.senderNameLbl.text = "\(member.firstName) \(member.lastName)"
//            }
//            strongSelf.senderImageView.imageFromURl(member.userImage, placeHolderImage: #imageLiteral(resourceName: "user"))
        }
        
        msgLbl.text = message.messageText
        
        let messageDate = Date(timeIntervalSince1970: message.messageTimestamp/1000)
        dateLbl.text = messageDate.timeAgoSince
    }
}
