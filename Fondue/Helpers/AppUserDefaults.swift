//
//  AppUserDefaults.swift
//  AppUserDefaults
//
//  Created by Gurdeep on 15/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON

enum AppUserDefaults { }

extension AppUserDefaults {
    
    static func value(forKey key: Key,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            print("No Value Found in UserDefaults\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
            
            return JSON.null
            
        }
        
        return JSON(value)
    }
    
    static func value<T>(forKey key: Key,
                      fallBackValue : T,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            print("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return JSON(fallBackValue)
        }
        
        return JSON(value)
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        
        //let tutorial = AppUserDefaults.value(forKey: .tutorialDisplayed).stringValue
        
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        
       // AppUserDefaults.save(value: tutorial, forKey: .tutorialDisplayed)
    }
    
}

//MARK : USAGE

// AppUserDefaults.value(forKey :.DOB)
// AppUserDefaults.value(forKey :.DOB, fallBackValue : "11/11/1989")



