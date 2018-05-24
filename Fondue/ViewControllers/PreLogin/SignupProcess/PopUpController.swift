//
//  PopUpController.swift
//  Fondue
//
//  Created by Nanak on 28/03/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class PopUpController: UIViewController {
    
    //MARK:- Properties
    //MARK:- ===========================
    
    var openUrl : String = ""
    var alertTitle : String = ""
    var alertMessage : String = ""
    var gotoText : String = "OK"
    var isTitleSepretor : Bool = false
    var isMessageSepretor : Bool = false
    var titleSeperatoeColor : UIColor = UIColor.black
    var messageSeperatoeColor : UIColor = UIColor.black
    var titleColor: UIColor = UIColor.black
    var messageColor: UIColor = UIColor.black
    var cancelBtnTitleColor: UIColor = UIColor.white
    var gototlBtnTitleColor: UIColor = UIColor.white
    var cancelBtnBgColor: UIColor = UIColor.white
    var gototlBtnBgColor: UIColor = UIColor.white
    var popUpBgColor: UIColor = UIColor.groupTableViewBackground
    var btnCornerRadius : CGFloat = 3
    var popupCornerRadius : CGFloat = 15
    var selectedDSP = SelectedDSPs.Spotify
    
    //MARK:- IBOutlets
    //MARK:- ===========================

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var gotoBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    
    //MARK:- Life cycles methods
    //MARK:- ===========================

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.1, animations: {
            self.bgView.alpha = 0.3
            
            self.view.layoutIfNeeded()
            
        }) { (Bool) in
            
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let point = touch.location(in: self.view)
        if !self.popUpView.frame.contains(point) {
            self.animatedDisapper()
        }
    }
    
    //MARK:- IBOutlets
    //MARK:- ===========================

    @IBAction func cancelBtnTap(_ sender: UIButton) {
        
        self.animatedDisapper()
        
    }
    
    @IBAction func gotoBtnTap(_ sender: UIButton) {
        self.animatedDisapper()

        if self.selectedDSP != .AppleMusic{
            if let url = URL(string : self.openUrl){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }else{
            NotificationCenter.default.post(name: NSNotification.Name("presentAppleSubscriptionNotification"), object: nil)
        }
    }
    
    //MARK:- Private Methods
    //MARK:- ===========================

   private func initialSetup(){
        
        self.bgView.alpha = 0.0
        AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
        self.titleLbl.text = self.alertTitle
        self.messageLbl.text = self.alertMessage
        self.messageLbl.font = AppFonts.Seravek_Medium.withSize(18)
        self.titleLbl.font = AppFonts.Seravek_Bold.withSize(20)
        self.popUpView.backgroundColor = self.popUpBgColor
        self.cancelBtn.setTitle(StringConstants.Cancel.localized, for: .normal)
        self.gotoBtn.setTitle(self.gotoText.localized.uppercased(), for: .normal)
        self.popUpView.layer.cornerRadius = self.popupCornerRadius
        self.cancelBtn.titleLabel?.font = AppFonts.Seravek_Medium.withSize(17.9)
        self.gotoBtn.titleLabel?.font = AppFonts.Seravek_Medium.withSize(17.9)
        self.cancelBtn.backgroundColor = UIColor.black
        self.gotoBtn.backgroundColor = AppColors.btnTextGreenLightColor
        self.cancelBtn.setTitleColor(UIColor.white, for: .normal)
        self.gotoBtn.setTitleColor(UIColor.white, for: .normal)
        self.gotoBtn.layer.cornerRadius = self.gotoBtn.bounds.height / 2
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.bounds.height / 2
    }
    
   private func appearPopupWithAnimation(){
      
        UIView.animate(withDuration: 0.1, animations: {
            self.bottomConstant.constant = 15

            self.view.layoutIfNeeded()
            
        }) { (true) in
        }

    }
    
    
   private func animatedDisapper(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bgView.alpha = 0.0
            self.view.layoutIfNeeded()

        }) { (true) in
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
