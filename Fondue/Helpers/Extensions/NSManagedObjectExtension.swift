

//
//  StringExtention.swift
//  NexGTv
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import CoreData

extension NSManagedObject
{
    
    ///Converts all properties into a 'Dictionary'
    var dictionary:[String:Any]
    {
        let keys = Array(self.entity.attributesByName.keys)
        let dict = self.dictionaryWithValues(forKeys: keys)
        return dict
    }
    
    ///Returns 'true' if the managed object is deleted, otherwise 'false'
    var hasDeleted:Bool{
        return self.managedObjectContext == nil
    }
}
