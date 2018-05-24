//
//  AppDelegate.swift
//  Onboarding
//
//  Created by Gurdeep Singh on 04/07/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FBSDKCoreKit
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var parentNavigationController = UINavigationController()

    var currentuser: ChatMember!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        sleep(3)

        self.window = UIWindow()
        self.window?.rootViewController = parentNavigationController
        self.window?.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().preventShowingBottomBlankSpace = false
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false


        application.registerForRemoteNotifications()
        
        self.registerForPushNotification()
        
        // remove next line its for testing

        NavigationManager.gotoLoginOption()
        
        // un commnet
//
//        guard let token = CurrentUser.accessToken, !token.isEmpty else {
//
//            NavigationManager.gotoLoginOption()
//
//            return true
//        }
//
//        if CurrentUser.isPlayListImported {
//
//            self.initialiseCurrentMember()
//            NavigationManager.gotoHome()
//
//        }else{
//
//            NavigationManager.gotoLoginOption()
//        }

        return true
        
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
      
        let auth = SpotifyManager.shared.sharedAuth
        
        if auth.canHandle(auth.redirectURL) {
            
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in

                if let _ = error {
                NotificationCenter.default.post(name: .dismissWebViewNotification, object: nil)

//                    showToastWithMessage("error : \(err)")
                    return
                }
                
                if let session = session {
                    let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                    AppUserDefaults.save(value: sessionData, forKey: .SpotifySession)
                    SpotifyManager.shared.spotifySessionDidLogin(success: true)
                    NotificationCenter.default.post(name: .dismissWebViewNotification, object: nil)
                }
                
            })
        }
        
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //MARK: Facebook related
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
    }
    
}

extension AppDelegate : UINavigationControllerDelegate  {
  
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        var n = viewController.description.components(separatedBy: ".")[1]
        n = n.components(separatedBy: ":").first!
    
    }

    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        var n = viewController.description.components(separatedBy: ".")[1]
        n = n.components(separatedBy: ":").first!
    }
    
}

