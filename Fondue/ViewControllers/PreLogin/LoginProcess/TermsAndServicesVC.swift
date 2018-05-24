//
//  TermsAndServicesVC.swift
//  Fondue
//
//  Created by Nanak on 22/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class TermsAndServicesVC: BaseVc {
    
    @IBOutlet weak var navigationLbl: UILabel!
    @IBOutlet weak var privacyText: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationLbl.font = AppFonts.Seravek.withSize(18)

        self.privacyText.isEditable = false
        self.navigationLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)

//        UIApplication.shared.statusBarStyle = .lightContent //or .default
//        setNeedsStatusBarAppearanceUpdate()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
    }
}
