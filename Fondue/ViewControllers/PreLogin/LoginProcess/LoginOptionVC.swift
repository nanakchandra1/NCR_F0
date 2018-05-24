//
//  HomeViewController.swift
//  Onboarding
//
//  Created by Appinventiv on 13/09/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginOptionVC: BaseVc {
    
    //MARK:- Properties
    //==================
    var spotiFyManager: SpotifyManager?
    
    //MARK:- IBOutlet
    //===============
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var makePlayListLabel: UILabel!
    @IBOutlet weak var conditionLabel: TTTAttributedLabel!
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
        
    }
    
    override func didReceiveMemoryWarning() {
        print_debug("memory issues \(self)")
    }
    
    private func initialSetup() {
        
        self.bgView.backgroundColor = AppColors.themeColor
        self.loginButton.backgroundColor = AppColors.btnTextGreenLightColor
        self.signupButton.backgroundColor = AppColors.btnTextGreenLightColor
        self.loginButton.setTitle(StringConstants.LOGIN.localized.uppercased(), for: .normal)
        self.signupButton.setTitle(StringConstants.Sign_up.localized.uppercased(), for: .normal)
        self.makePlayListLabel.font = AppFonts.Seravek.withSize(20.0)
        self.makePlayListLabel.text = "MAKE PLAYLISTS WITH FRIENDS"
        self.makePlayListLabel.textColor = UIColor.white
        self.makePlayListLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        self.signupButton.titleLabel?.font = AppFonts.Seravek_Medium.withSize(16)
        self.loginButton.titleLabel?.font = AppFonts.Seravek_Medium.withSize(16)
        self.signupButton.titleLabel?.transform = CGAffineTransform(scaleX: 1.0, y: 1.1)
        self.loginButton.titleLabel?.transform = CGAffineTransform(scaleX: 1.0, y: 1.1)

        self.conditionLabel.delegate = self
        
        self.conditionLabel.font = AppFonts.Seravek.withSize(11.5)
        self.conditionLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)

        self.conditionLabel.linkAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: AppFonts.Seravek.withSize(11.5),
            NSAttributedStringKey.underlineStyle: NSNumber(value: NSUnderlineStyle.styleNone.rawValue)
        ]
        self.conditionLabel.text = StringConstants.Terms_Condition.localized
        let str:NSString = self.conditionLabel.text! as NSString
        let range : NSRange = str.range(of: StringConstants.T_S.localized)
        self.conditionLabel.addLink(to: NSURL(string: "abc")! as URL!, with: range)
    }
    
}


//MARK:- TTTAtributedLbel Delegate method
//MARK:- ==============================

extension LoginOptionVC : TTTAttributedLabelDelegate{
    // attriuted label didselect method
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        NavigationManager.gotoTermsCondition(from: self)
        
    }
    
}
//MARK:- IBActions
//================
extension LoginOptionVC {
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        NavigationManager.signupLoginOption(with: .signUp)
//        AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))

    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        NavigationManager.signupLoginOption(with: .login)

    }
    
}
