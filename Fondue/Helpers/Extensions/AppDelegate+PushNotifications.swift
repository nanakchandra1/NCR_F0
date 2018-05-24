//
//  AppDelegate+PushNotifications.swift
//  Onboarding
//
//  Created by Appinventiv on 13/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SwiftyJSON
import Firebase

//MARK:
//MARK: Remote push notification methods/delegates

extension AppDelegate : UNUserNotificationCenterDelegate{
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        guard (userInfo["aps"] as? [String : Any]) != nil else{
            return
        }
        
        if application.applicationState == .inactive {
            
            self.pushAction(forInfo: userInfo, state: application.applicationState)
            
        }else{
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Auth.auth().setAPNSToken(deviceToken, type: .prod)

        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        DeviceDetail.deviceToken = token

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        
    }
    
    func registerForPushNotification(){

        if #available(iOS 10.0, *) {
                let center  = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    if error == nil{
                        
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            } else {
                
                let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
    }
    
    func pushAction(forInfo userInfo : [AnyHashable: Any],state : UIApplicationState){
        
        guard let aps = userInfo["aps"] as? [String : Any] else{
            return
        }
        
        if let type = aps["type"] ,let pushType : PushType = PushType(rawValue: "\(type)"){
            
            
        }
    }
    
    
    func initialiseCurrentMember(){
        
        let user_id = CurrentUser.user_id ?? ""
        let email = "\(user_id)@gmail.com"
//        let password = "1234567890"
        
        var params = JSONDictionary()
        params["userId"] = user_id
        params["firstName"] = email
        params["lastName"] = email
        params["deviceToken"] = "123456"
        let json = JSON(params)
        
        sharedAppDelegate.currentuser = ChatMember(with: json)
    }
}

enum PushType : String {
    
    case push
}


//MARK:-  functions

extension AppDelegate: UITabBarDelegate,UITabBarControllerDelegate {
    
    

}
