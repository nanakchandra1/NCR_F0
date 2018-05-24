//
//  DeezerObject.swift
//  Fondue
//
//  Created by Nanak on 20/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import Foundation

struct DeezerObject {
    
    let title: String
    let type: DeezerObjectType
    var object: DZRObject?
    
    init(title: String, type: DeezerObjectType, object: DZRObject? = nil) {
        self.title = title
        self.type = type
        self.object = object
    }
}
