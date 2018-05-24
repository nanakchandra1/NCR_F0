//
//  ImportPlaylistModel.swift
//  Onboarding
//
//  Created by macOS on 13/02/18.
//  Copyright © 2018 Gurdeep Singh. All rights reserved.
//

import Foundation
import SwiftyJSON

class ImportPlaylistModel {
    
    var playListName: String!
   
    
    init(param: JSON) {
        self.playListName = param["playListName"].stringValue
        
    }
}
