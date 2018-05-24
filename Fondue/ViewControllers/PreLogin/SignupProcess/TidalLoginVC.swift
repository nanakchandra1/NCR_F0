//
//  TidalLoginVC.swift
//  Fondue
//
//  Created by Nanak on 27/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit


struct TidalConstants {
    
    //https://api.tidalhifi.com/v1/users/
    
    struct APIDetails {
        
        static let APIScheme = "https"
        static let APIHost = "api.tidalhifi.com"
        static let APIPath = "/v1/users/\(CurrentUser.tidal_user_id!)/"
        static let APIPathTrcak = "/v1/"

    }
    
    static var userId = ""
}


protocol TidalLoginDelegate {
    func tidelLogin(isOpen: Bool)
}


class TidalLoginVC: BaseVc {

    @IBOutlet weak var connectLbl: UILabel!
    @IBOutlet weak var loginWithLbl: UILabel!
    @IBOutlet weak var userNameTExtField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var authorizationLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    

    var delegate: TidalLoginDelegate!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialSetup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }

    
    private func initialSetup(){
        
        self.connectLbl.font = AppFonts.Seravek_Medium.withSize(17)
        self.loginWithLbl.font = AppFonts.Seravek.withSize(15)
        self.loginBtn.backgroundColor = AppColors.btnTextGreenLightColor

        self.authorizationLbl.font = AppFonts.Seravek_Light.withSize(13)
        self.loginBtn.layer.cornerRadius = 10
        self.userNameTExtField.isSecureText = false
        self.userNameTExtField.attributedPlaceholder   = NSAttributedString(string: "Email Address",                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        self.passTextField.attributedPlaceholder   = NSAttributedString(string: "Password",                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])

    }
    

    
    private func tidalLoginService(){
        
        var details = [String:Any]()
        
        details["user_name"] = self.userNameTExtField.text ?? ""
        details["password"] = self.passTextField.text ?? ""
        details["device_token"] = DeviceDetail.deviceToken
        details["device_id"] = DeviceDetail.device_id
        details["device_model"] = DeviceDetail.device_model
        details["os_version"] = DeviceDetail.os_version
        details["platform"] = "2"
        
        // https://api.tidalhifi.com/v1/users/44198981/playlists?countryCode=US&sessionId=76cb17f2-0f92-4a67-b4ca-26102c8155fa
        

        WebServices.tidalSignUpAPI(parameters: details, webServiceSuccess: { (msg, json, code) in
            
            if code == error_codes.success{
                
                if let token = CurrentUser.accessToken, !token.isEmpty{
                    
                    let tidal_user_id = json["tidal_user_id"].stringValue
                    
                    if let tidal_countryCode = json["tidal_countryCode"].string , !tidal_countryCode.isEmpty{
                        
                        AppUserDefaults.save(value: tidal_countryCode, forKey: .tidal_countryCode)
                        
                    }else{
                        
                        AppUserDefaults.save(value: "US", forKey: .tidal_countryCode)
                        
                    }
                    
                    let tidal_session_id = json["tidal_session_id"].stringValue
                    
                    AppUserDefaults.save(value: tidal_session_id, forKey: .tidal_session_id)
                    AppUserDefaults.save(value: tidal_user_id, forKey: .tidal_user_id)
                    
                }else{
                    let userDetail = User(json: json)
                    saveToUserDefault(userDetail)
                }
                
                self.delegate.tidelLogin(isOpen: true)
                
                sharedAppDelegate.parentNavigationController.dismiss(animated: true, completion: nil)

            }else if code == error_codes.userSubscribe{
                
                let url = json["subscribe"].stringValue
                
                NavigationManager.showPopUP(title: "Not a premium member", message: "For becoming premium member, use Tidal account for purchasing subscription." , url : url)

            }else{
                
                showToastWithMessage(msg)
            }
            
        }) { (err) -> (Void) in
            
        }
    }
    

    private func loginDisableEnable(_ isEnable: Bool){
        
        if isEnable{
            self.loginBtn.isEnabled = true
            self.loginBtn.backgroundColor = AppColors.btnBackGroundDarkColor
        }else{
            self.loginBtn.isEnabled = false
            self.loginBtn.backgroundColor = UIColor.darkGray
        }
    }

    @IBAction func cancelBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)

        sharedAppDelegate.parentNavigationController.dismiss(animated: true, completion: nil)
        self.delegate.tidelLogin(isOpen: false)

    }
    
    @IBAction func loginBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)

        if self.userNameTExtField.text!.checkIfInvalid(.email) {
            
            showToastWithMessage(StringConstants.Invalid_Email.localized)
            
            return
        }else{
            self.tidalLoginService()
        }

       // sharedAppDelegate.parentNavigationController.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func emailtextChanged(_ sender: UITextField) {
        
        if self.userNameTExtField.hasText && self.passTextField.hasText{
            self.loginDisableEnable(true)
        }else{
            
            self.loginDisableEnable(false)

        }
        
        print_debug(sender.text)
    }
    @IBAction func passtextChanged(_ sender: UITextField) {
        
        if self.userNameTExtField.hasText && self.passTextField.hasText{
            self.loginDisableEnable(true)

        }else{
            self.loginDisableEnable(false)
        }
    }

}
