//
//  TabBarVC.swift
//  Fondue
//
//  Created by Nanak on 17/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.addPlayer(notificatin:)), name: .addPlayerNotification, object: nil)
        self.tabBar.itemPositioning = .fill
        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: AppFonts.Seravek.withSize(8)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: AppFonts.Seravek.withSize(8)], for: .selected)
    
        
        for v in self.tabBar.subviews {
            
            v.transform = CGAffineTransform(scaleX: 1.0, y: 1.1)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addPlayer(notificatin : Notification){
        guard let info = notificatin.userInfo!["tracks"] as? [TracksModel] else{return}
        CommonClass.addBottomTrackView(viewController: self)
        NotificationCenter.default.post(name: .playSongNotification, object: nil, userInfo: ["tracks" : info])//(name: .playSongNotification, object: nil)
    }
}
