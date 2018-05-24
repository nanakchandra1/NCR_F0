//
//  TidelPlayListModel.swift
//  Fondue
//
//  Created by Nanak on 27/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import Foundation
import SwiftyJSON

class TidelPlayListModel {
    
    var description: String
    var uuid : String
    var type : String
    var image : String
    var title : String
    var url : String

    init(data : JSON) {
        
        self.description = data["description"].stringValue
        self.uuid = data["uuid"].stringValue
        self.type = data["type"].stringValue
        self.image = data["image"].stringValue
        self.title = data["title"].stringValue
        self.url = data["url"].stringValue

    }
}



class TidelPlayListTrackModel {
    
    var album: TrackAlbumModel
    var allowStreaming : Bool
    var artist : TrackArtistModel
    var audioQuality : String
    var copyright : String
    var duration : String
    var editable : Bool
    var explicit : String
    var id : String
    var isrc : String
    var peak : String
    var popularity : String
    var premiumStreamingOnly : Bool
    var replayGain : String
    var streamReady : String
    var streamStartDate : String
    var title : String
    var trackNumber : String
    var url : String
    var volumeNumber : String

    init(data : JSON) {
        
        let albm = data["album"]
        let artst = data["artist"]
        self.album = TrackAlbumModel(with: albm)
        self.allowStreaming = data["allowStreaming"].boolValue
        self.artist = TrackArtistModel(with: artst)
        self.audioQuality = data["audioQuality"].stringValue
        self.title = data["title"].stringValue
        self.url = data["url"].stringValue
        self.copyright = data["copyright"].stringValue
        self.duration = data["duration"].stringValue
        self.editable = data["editable"].boolValue
        self.explicit = data["explicit"].stringValue
        self.id = data["id"].stringValue
        self.isrc = data["isrc"].stringValue
        self.peak = data["peak"].stringValue
        self.popularity = data["popularity"].stringValue
        self.premiumStreamingOnly = data["premiumStreamingOnly"].boolValue
        self.replayGain = data["replayGain"].stringValue
        self.streamReady = data["streamReady"].stringValue
        self.streamStartDate = data["streamStartDate"].stringValue
        self.trackNumber = data["trackNumber"].stringValue
        self.volumeNumber = data["volumeNumber"].stringValue
    }
    
}


class TrackArtistModel{
    
    var id: String!
    var name : String!
    var type : String!

    init(with data : JSON) {
        
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue
        self.type = data["type"].stringValue

    }
}

class TrackAlbumModel{
    
    var id: String!
    var title : String!
    var cover : String!
    var releaseDate : String!

    init(with data : JSON) {
        self.id = data["id"].stringValue
        self.title = data["title"].stringValue
        self.cover = data["cover"].stringValue
        self.releaseDate = data["releaseDate"].stringValue
    }
}

