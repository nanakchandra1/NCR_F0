//
//  SpotifyPlayListModel.swift
//  Fondue
//
//  Created by Nanak on 20/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SpotifyPlayListModel {
    
    var title : String
    var tracklistUrl : String
    var type : String
    var id : String
    var picture : SpotifyPlayListImages
    var uri : String
    var snapshot_id : String
    var collaborative : Int
    var owner : SpotifyPlayListOwner
    
    init(with data : JSON) {
        
        self.title = data["name"].stringValue
        
        let tracks = data["tracks"]
        self.tracklistUrl = tracks["href"].stringValue
        
        self.type = data["type"].stringValue
        self.id = data["id"].stringValue
        
        let creater = data["owner"]
        self.owner = SpotifyPlayListOwner(with: creater)
        
        self.collaborative = data["collaborative"].intValue
        self.snapshot_id = data["snapshot_id"].stringValue
        
        let images = data["images"].arrayValue
        self.picture = SpotifyPlayListImages(with: images)

        self.uri = data["uri"].stringValue
    }
}

struct SpotifyPlayListOwner {
    
    var display_name : String
    var id : String
    var type : String
    var uri : String
    
    init(with data : JSON) {
        
        self.display_name = data["display_name"].stringValue
        self.id = data["id"].stringValue
        self.type = data["type"].stringValue
        self.uri = data["uri"].stringValue

    }

}

struct SpotifyPlayListImages {
    
    var largeImage :String = ""
//    var mediumImage :String = ""
//    var smallImage :String = ""
    
    init(with data : [JSON]) {
        
        if !data.isEmpty{
            self.largeImage = data.first!["url"].stringValue
        }
        
//        for res in data{
//
//            let height = res["height"].intValue
//
//            switch height{
//
//            case 640 :
//
//                self.largeImage = res["url"].stringValue
//
//            case 300 :
//
//                self.mediumImage = res["url"].stringValue
//
//
//            case 60 :
//                self.smallImage = res["url"].stringValue
//
//            default:
//
//                self.smallImage = res["url"].stringValue
//            }
//        }
    }
}


struct SpotifyTracksModel {
    
    var name : String
    var uri : String
    var duration_ms : Int
    var type : String
    var id : String
    var album : SpotifyTrackAlbumModel
    var artist = SpotifyTrackArtistModel()

    init(with info : JSON) {
        
        let data = info["track"]
        self.name = data["name"].stringValue
        self.uri = data["uri"].stringValue
        self.duration_ms = data["duration_ms"].intValue
        self.type = data["type"].stringValue
        self.id = data["id"].stringValue
        
        let album = data["album"]
        self.album = SpotifyTrackAlbumModel(with: album)
        
        let artist = data["artists"].arrayValue
        
        if !artist.isEmpty{
            
            self.artist = SpotifyTrackArtistModel(with: artist.first!)
        }
    }
}


struct SpotifyTrackAlbumModel {
    
    var release_date : String
    var name : String
    var id : String
    var uri : String
    var type : String
    var picture : SpotifyPlayListImages


    init( with data : JSON) {
        
        self.release_date = data["release_date"].stringValue
        self.name = data["name"].stringValue
        self.id = data["id"].stringValue
        self.uri = data["uri"].stringValue
        self.type = data["type"].stringValue
        
        let images = data["images"].arrayValue
        self.picture = SpotifyPlayListImages(with: images)

    }
    
}


struct SpotifyTrackArtistModel {
    
    var release_date : String = ""
    var name : String = ""
    var id : String = ""
    var uri : String = ""
    var type : String = ""
    
    init( with data : JSON) {
        
        self.release_date = data["release_date"].stringValue
        self.name = data["name"].stringValue
        self.id = data["id"].stringValue
        self.uri = data["uri"].stringValue
        self.type = data["type"].stringValue
        
        
    }

    init() {
        
    }

}
