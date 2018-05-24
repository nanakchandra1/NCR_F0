//
//  DispatchQueueExtension.swift
//  WashApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import UIKit

extension DispatchQueue{
    
    ///Delays the executon of 'closer' block upto a given time
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        
        self.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    ///Returns the main queue asynchronuously
    class func mainQueueAsync(_ closure:@escaping ()->()){
        self.main.async(execute: {
            closure()
        })
    }
    
    ///Returns the main queue synchronuously
    class func mainQueueSync(_ closure:@escaping ()->()){
        self.main.sync(execute: {
            closure()
        })
    }
    
    ///Returns the background queue asynchronuously
    class func backgroundQueueAsync(_ closure:@escaping ()->()){
        self.global().async(execute: {
            closure()
        })
    }
    
    ///Returns the background queue synchronuously
    class func backgroundQueueSync(_ closure:@escaping ()->()){
        self.global().sync(execute: {
            closure()
        })
    }
}
