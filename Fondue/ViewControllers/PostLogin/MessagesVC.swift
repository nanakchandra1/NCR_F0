//
//  MessagesVC.swift
//  Fondue
//
//  Created by Nanak on 22/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase


class MessagesVC: BaseVc {

    //MARK:- PROPERTIES
    //=================
    private var chats: [Inbox] = []

    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var underDevLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.chatListTableView.isHidden = true
        self.initialSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- Private Functions
//MARK:- ==========================

extension MessagesVC{
    
    private func initialSetUp(){
        
        self.chatListTableView.delegate = self
        self.chatListTableView.dataSource = self
        self.chatListTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navTitleLabel.font = AppFonts.Seravek.withSize(18)
        self.view.backgroundColor = AppColors.lightBlueColor
        self.navTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        self.underDevLbl.font = AppFonts.Seravek.withSize(18)

//        observeInbox()

    }
    
    fileprivate func moveToChat(_ chat: Inbox) {
        
        let chatScene = ChatVC.instantiate(fromAppStoryboard: .Chat)
        let dict = [DatabaseNode.RoomInfo.roomId.rawValue: chat.roomId,
                    DatabaseNode.RoomInfo.chatTitle.rawValue: chat.chatRoom?.chatRoomTitle ?? chat.chatMember?.firstName]
        
        if let id = chat.chatMember?.userID {
            chatScene.senderId = id
        }
        
        let json = JSON(dict)
        
        let chatRoomInfo = ChatRoom(with: json)
        chatScene.chatRoomInfo = chatRoomInfo
        chatScene.chatMembers = [chat.chatMember!]
        chatScene.chat = .existing
        sharedAppDelegate.parentNavigationController.pushViewController(chatScene, animated: true)
    }
}

// MARK: Database Methods
private extension MessagesVC {
    
    func observeInbox() {
        
        let currentUserId = sharedAppDelegate.currentuser.userID
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(currentUserId).observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value as? String else {
                    
                    return
            }
            
            
//            let chat = Inbox(with: JSON(value))
            let chat = Inbox(with: value)

            
            strongSelf.chats.append(chat)
            
            /*
             if let index = Array(strongSelf.chats).index(of: chat) {
             let indexToBeInserted = IndexPath(row: index, section: 0)
             strongSelf.chatListTableView.insertRows(at: [indexToBeInserted], with: .fade)
             
             if index == 0 {
             strongSelf.chatListTableView.reloadEmptyDataSet()
             }
             }
             */
            
            print_debug("\(snapshot.key) \(value)")
            
            print_debug("ROOM_ID : \(chat.roomId)")
            
//            strongSelf.getLastMessage(chat.roomId)
            
            if snapshot.key == chat.roomId {
                
                print_debug("\(value) is group")
                strongSelf.getGroupDetails(chat.roomId)
                
            } else {
                
                print_debug("\(value) is single")
                strongSelf.getUserDetails(snapshot.key, roomId: chat.roomId)
            }
            
            }, withCancel: { [weak self] (error) in
                
                guard let strongSelf = self else {
                    return
                }
                
                DispatchQueue.mainQueueAsync {
                    strongSelf.chatListTableView.reloadData()
                }
                
        })
        
        /*
         DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(currentUserId).observe(.childRemoved, with: { [weak self] (snapshot) in
         
         guard let strongSelf = self,
         let value = snapshot.value as? String else {
         return
         }
         
         }
         */
    }
    
    func getUserDetails(_ userId: String, roomId: String) {
        let node: DatabaseNode.Root = .users
        
        DatabaseReference.child(node.rawValue).child(userId).observe(.value) { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.parseRoomInfo(from: snapshot, for: roomId, userId: userId, of: node)
        }
    }
    
    func getLastMessage(_ roomId: String) {
        fetchDetails(from: .lastMessage, for: roomId)
    }
    
    func getGroupDetails(_ roomId: String) {
        fetchDetails(from: .roomInfo, for: roomId)
    }
    
    func fetchDetails(from node: DatabaseNode.Root, for id: String) {
        
        DatabaseReference.child(node.rawValue).child(id).observe(.value) { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.parseRoomInfo(from: snapshot, for: id, userId: nil, of: node)
        }
    }
    
    func parseRoomInfo(from snapshot: DataSnapshot, for roomId: String, userId: String?, of node: DatabaseNode.Root) {
        
        guard let value = snapshot.value else {
            return
        }
        print_debug("\(node.rawValue): \(value)")
        
        let json = JSON(value)
        
        guard var chat = chats.filter({$0.roomId == roomId}).first else {
            return
        }
        
        if node == .lastMessage {
            let lastMessage = MessageModel(with: json[])
            chat.lastMessage = lastMessage
        }else if node == .roomInfo {
            let chatRoom = ChatRoom(with: json)
            chat.chatRoom = chatRoom
        }else if node == .users {
            let chatMember = ChatMember(with: json)
            chat.chatMember = chatMember
        }
        
        if let chatIndex = chats.index(where: { (chat) -> Bool in
            return chat.roomId == roomId
        }) {
            chats[chatIndex] = chat
        }
        refreshCell(for: chat)
        
    }
    
    func refreshCell(for chat: Inbox) {
        
        DispatchQueue.mainQueueAsync { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            let chats = Array(strongSelf.chats)
            
            guard let index = chats.index(of: chat) else {
                return
            }
            
            if index < strongSelf.chatListTableView.numberOfRows(inSection: 0) {
                let indexPath = IndexPath(row: index, section: 0)
                strongSelf.chatListTableView.reloadRows(at: [indexPath], with: .fade)
            }
            else {
                strongSelf.chatListTableView.reloadData()
            }
        }
    }
}

//MARK:- UITableview delegate and datasource methods
//MARK:- ==========================

extension MessagesVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        cell.populateData(chats[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToChat(chats[indexPath.row])
    }
}


class ChatListCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var msgReceavedDate: UILabel!
    @IBOutlet weak var msgCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func populateData(_ inbox : Inbox) {
        
        let imageUrl = inbox.chatRoom?.chatRoomPic ?? inbox.chatMember?.userImage ?? ""
        
//        chatImageView.imageFromURl(imageUrl, placeHolderImage: #imageLiteral(resourceName: "user"))
        userName.text = inbox.chatRoom?.chatRoomTitle ?? inbox.chatMember?.firstName
//        lastMessageLabel.text = inbox.lastMessage?.messageText
//        updatedTimeLabel.text = Date(timeIntervalSince1970: inbox.lastMessage?.messageTimestamp ?? 0).timeAgoSince
    }

    
}
