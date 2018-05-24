//
//  WebViewVC.swift
//  Fondue
//
//  Created by Nanak on 24/05/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class WebViewVC: BaseVc {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var crossBtn: UIButton!
    
    var url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissView), name: .dismissWebViewNotification, object: nil)
        let myRequest = URLRequest(url: self.url)
        self.webView.loadRequest(myRequest)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dismissWebViewNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func crossBtnTap(_ sender: UIButton) {
        
        self.dismissView()
    }
    
    
    
    @objc func dismissView(){
        sharedAppDelegate.parentNavigationController.dismiss(animated: true, completion: nil)

    }

    
}
