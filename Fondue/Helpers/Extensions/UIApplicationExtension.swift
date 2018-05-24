//
//  UIApplicationExtension.swift
//  WashApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import UIKit

extension UIApplication{
    
    ///Opens Settings app
    @nonobjc class var openSettingsApp:Void{
        
        if #available(iOS 10.0, *) {
            self.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    ///Disables the ideal timer of the application
    @nonobjc class var disableApplicationIdleTimer:Void {
        self.shared.isIdleTimerDisabled = true
    }
    
    ///Enables the ideal timer of the application
    @nonobjc class var enableApplicationIdleTimer:Void {
        self.shared.isIdleTimerDisabled = false
    }
    
    ///Can get & set application icon badge number
    @nonobjc class var appIconBadgeNumber:Int{
        get{
          return UIApplication.shared.applicationIconBadgeNumber
        }
        set{
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
}
