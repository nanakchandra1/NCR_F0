//
//  NotificationExtension.swift
//  Fondue
//
//  Created by Nanak on 15/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import Foundation

extension NSNotification.Name{
    
    public static let relodNotification = Notification.Name(rawValue: "relodNotification")
    public static let spotifiLoginSuccess = Notification.Name(rawValue: "loginSuccessfull")
    public static let getAccessTokenNotification = Notification.Name(rawValue: "getAccessTokenNotification")
    public static let addPlayerNotification = Notification.Name(rawValue: "addPlayerNotification")
    public static let playSongNotification = Notification.Name(rawValue: "playSongNotification")


    public static let dismissWebViewNotification = Notification.Name(rawValue: "dismissWebViewNotification")

}
