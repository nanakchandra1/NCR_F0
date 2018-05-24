//
//  AppNetworking+Loader.swift
//  StarterProj
//
//  Created by Gurdeep on 06/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

import Foundation
import UIKit
import KVNProgress

extension AppNetworking {
    
     static func showLoader() {
        loader.start()
    }
    
     static func hideLoader() {
        loader.stop()
    }
    
}


var loader = __Loader(frame: CGRect.zero)
class __Loader : UIView {
    
    var activityIndicator : UIActivityIndicatorView!
    
    var isLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        let innerView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
        innerView.addSubview(self.activityIndicator)
        self.activityIndicator.center = innerView.center
        innerView.center = self.center
        innerView.addSubview(self.activityIndicator)
        
        self.addSubview(innerView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func start() {
        
        if self.isLoading { return }
        
        sharedAppDelegate.window?.addSubview(self)
        self.activityIndicator.startAnimating()
        
        self.isLoading = true
    }
    
    func stop() {
        
        self.activityIndicator.stopAnimating()
        self.removeFromSuperview()
        self.isLoading = false
        
    }
}



//MARK:-=====


extension AppNetworking {
    
    static func addLoader() {
        __loaderTemp.start()
    }
    
    static func removeLoader() {
        __loaderTemp.stop()
    }
}



var __loaderTemp = __LoaderTemp(frame: CGRect.zero)
class __LoaderTemp : UIView {
    
    var activityIndicator : UIActivityIndicatorView!
    
    var isLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        let innerView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
        innerView.addSubview(self.activityIndicator)
        self.activityIndicator.center = innerView.center
        innerView.center = self.center
        innerView.addSubview(self.activityIndicator)
        
        self.addSubview(innerView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func start() {
        
        if self.isLoading { return }
        
        sharedAppDelegate.window?.addSubview(self)
        self.activityIndicator.startAnimating()
        
        self.isLoading = true
    }
    
    func stop() {
        
        self.activityIndicator.stopAnimating()
        self.removeFromSuperview()
        self.isLoading = false
        
    }
    
}
