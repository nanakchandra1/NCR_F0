//
//  HomeModel.swift
//  Onboarding
//
//  Created by macOS on 13/02/18.
//  Copyright © 2018 Gurdeep Singh. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlayListModel {
    
    var playList: String
    var uri: String
    var image: String
    var source_id: String
    var source: String
    var title: String
    var playlistId: String
    var userDetail : User
    var tracks = [TracksModel]()
    
    init(data: JSON) {
        
        self.playlistId = data["_id"].stringValue
        self.playList = data["name"].stringValue
        self.uri = data["uri"].stringValue
        self.image = data["image"].stringValue
        self.source_id = data["source_id"].stringValue
        self.source = data["source"].stringValue
        self.title = data["title"].stringValue
        let owner = data["owner"]
        self.userDetail = User(json: owner)
        
        self.getPlayListTracks(with: self.playlistId) { (trackList) in
            self.tracks = trackList
            NotificationCenter.default.post(name: Notification.Name("reloadTable"), object: nil)
        }
        
    }
    
    private func getPlayListTracks(with playlistId : String , successBlock : @escaping ([TracksModel]) -> Void) {
        
        var params = JSONDictionary()
        
        params["token"] = CurrentUser.accessToken
        
        params["playlist"] = playlistId
        
        WebServices.getPlaylistTracksAPI(parameters: params, webServiceSuccess: { (success, msg, json) in
            
            if success{
                
                let teacks = json.map({ (track) -> TracksModel in
                    TracksModel(data: track)
                })
                
                successBlock(teacks)
                
            }else{
                
                showToastWithMessage(msg)
                
            }
        }) { (err) -> (Void) in
            showToastWithMessage(err.localizedDescription)
        }
    }
}



class TracksModel {
    
    var playList: String
    var uri: String
    var image: String
    var source_id: String
    var source: String
    var title: String
    var duration: Int

    
    init(data: JSON) {
        
        self.playList = data["name"].stringValue
        self.uri = data["uri"].stringValue
        self.image = data["image"].stringValue
        self.source_id = data["source_id"].stringValue
        self.source = data["source"].stringValue
        self.title = data["title"].stringValue
        self.duration = data["duration"].intValue

    }
}
