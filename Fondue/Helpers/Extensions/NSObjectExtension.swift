//
//  NSObjectExtension.swift
//  WashApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import UIKit

 extension NSObject{
    
    ///Retruns the name of the class
    class var className: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    ///Retruns the name of the class
    var className: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}
