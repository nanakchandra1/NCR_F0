//
//  DeezerPlaylistModel.swift
//  Fondue
//
//  Created by Nanak on 20/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DeezerPlaylistModel {
    
    var duaration : Int
    var link : String
    var picture : String
    var picture_big : String
    var picture_medium : String
    var picture_small : String
    var picture_xl : String
    var title : String
    var tracklistUrl : String
    var type : String
    var creation_date : String
    var id : String
    var creater : Creator
    
    init(with data : JSON) {
        
        self.duaration = data["duaration"].intValue
        self.link = data["link"].stringValue
        self.picture = data["picture"].stringValue
        self.picture_big = data["picture_big"].stringValue
        self.picture_medium = data["picture_medium"].stringValue
        self.picture_small = data["picture_small"].stringValue
        self.picture_xl = data["picture_xl"].stringValue
        self.title = data["title"].stringValue
        self.tracklistUrl = data["tracklist"].stringValue
        self.type = data["type"].stringValue
        self.creation_date = data["creation_date"].stringValue
        self.id = data["id"].stringValue

        let creater = data["creater"]
        self.creater = Creator(with: creater)
        
    }
}


struct Creator {
    
    var id : String
    var name : String
    var tracklist : String
    var type : String
    
    init(with data : JSON) {
        
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue
        self.tracklist = data["tracklist"].stringValue
        self.type = data["type"].stringValue

        
    }
    
}








struct DeezerTracklistModel {
    
    var duaration : Int
    var link : String
    var preview : String
    var rank : Int
    var time_add : Int
    var title : String
    var title_short : String
    var type : String
    var id : String
    var album : TrackAlbumModel
    var artist : TrackArtistModel
    
    
    init(with data : JSON) {
        
        self.duaration = data["duaration"].intValue
        self.link = data["link"].stringValue
        self.preview = data["preview"].stringValue
        self.rank = data["rank"].intValue
        self.time_add = data["time_add"].intValue
        self.title = data["title"].stringValue
        self.title_short = data["title_short"].stringValue
        self.type = data["type"].stringValue
        self.id = data["id"].stringValue

        let album = data["album"]
        self.album = TrackAlbumModel(with: album)
        
        let artist = data["artist"]
        self.artist = TrackArtistModel(with: artist)
        
    }
}


struct TrckAlbum {
    
    var cover : String
    var cover_big : String
    var cover_medium : String
    var cover_small : String
    var cover_xl : String
    var tracklistUrl : String
    var id : String
    var title : String
    var type : String
    

    init(with data : JSON) {
        
        self.cover = data["cover"].stringValue
        self.cover_big = data["cover_big"].stringValue
        self.cover_medium = data["cover_medium"].stringValue
        self.cover_small = data["cover_small"].stringValue
        self.cover_xl = data["cover_xl"].stringValue
        self.title = data["title"].stringValue
        self.tracklistUrl = data["tracklist"].stringValue
        self.type = data["type"].stringValue
        self.id = data["id"].stringValue
        
    }
}


struct TrckArtist {
    
    var id : String
    var name : String
    var link : String
    var picture : String
    var picture_big : String
    var picture_medium : String
    var picture_small : String
    var picture_xl : String
    var tracklistUrl : String
    var type : String
    
    init(with data : JSON) {
        
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue
        self.link = data["link"].stringValue
        self.picture = data["picture"].stringValue
        self.picture_big = data["picture_big"].stringValue
        self.picture_medium = data["picture_medium"].stringValue
        self.picture_small = data["picture_small"].stringValue
        self.picture_xl = data["picture_xl"].stringValue
        self.tracklistUrl = data["tracklist"].stringValue
        self.type = data["type"].stringValue
        
    }
    
}





