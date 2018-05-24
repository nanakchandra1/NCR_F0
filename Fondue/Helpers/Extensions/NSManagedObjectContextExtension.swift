//
//  StringExtention.swift
//  NexGTv
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext
{
    
    ///Deletes all core data record
    var deleteAllData:Void{
        
        guard let persistentStore = persistentStoreCoordinator?.persistentStores.last, let url = persistentStoreCoordinator?.url(for: persistentStore) else {
            return
        }
        
        performAndWait { () -> Void in
            self.reset()
            do
            {
                try self.persistentStoreCoordinator?.remove(persistentStore)
                try FileManager.default.removeItem(at: url)
                try self.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            }
            catch { /*dealing with errors up to the usage*/ }
        }
    }
}
