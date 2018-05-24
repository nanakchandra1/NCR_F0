//
//  Globals.swift
//  Onboarding
//
//  Created by Appinventiv on 22/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit

let UDER_DEVELOPEMENT = "Under Development"

let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate


// MARK:- Main Screen Size
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenSize = UIScreen.main.bounds.size


extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}

func print_debug <T> (_ object: T) {
    
    // TODO: Comment Next Statement To Deactivate Logs
    print(object)
    
}

var isSimulatorDevice:Bool {
    
    var isSimulator = false
    #if arch(i386) || arch(x86_64)
        //simulator
        isSimulator = true
    #endif
    return isSimulator
}

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}


func getJsonObject(_ Detail: Any) -> String{
    
    var data = Data()
    do {
        data = try JSONSerialization.data(
            withJSONObject: Detail ,
            options: JSONSerialization.WritingOptions(rawValue: 0))
    }
    catch{
        
    }
    
    let paramData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    return paramData
    
}


//MARK:- ===========================
//MARK:- ShowToast

func showToastWithMessage(_ msg: String){
    sharedAppDelegate.window?.makeToast(msg)
}


extension Collection where Iterator.Element == JSONDictionary {
    
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? JSONDictionaryArray,
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
    
}

func clearTokenAndExpirationDate() {
    
    KeyChainManager.delete(key: DeezerConstant.KeyChain.deezerUserIdKey)
    KeyChainManager.delete(key: DeezerConstant.KeyChain.deezerTokenKey)
    KeyChainManager.delete(key: DeezerConstant.KeyChain.deezerExpirationDateKey)
}

func makeLbl(view: UIView,msg: String, color: UIColor) -> UILabel{
    
    let tablelabel = UILabel(frame: CGRect(x: view.center.x, y: view.center.y, width: view.frame.width, height: view.frame.height))
    
    tablelabel.font = UIFont.systemFont(ofSize: 17)
    
    tablelabel.textColor = color
    
    tablelabel.textAlignment = .center
    
    tablelabel.text = msg
    
    return tablelabel
    
}

func showNodata(_ data: [Any], tableView: UITableView, msg: String, color: UIColor){
    
    if data.isEmpty{
        
        tableView.backgroundView = makeLbl(view: tableView, msg: msg, color: color)
        
        tableView.backgroundView?.isHidden = false
        
    }else{
        
        tableView.backgroundView?.isHidden = true
        
    }
    
}


func saveToUserDefault(_ user: User){
    
    AppUserDefaults.save(value: user.displayName, forKey: .displayName)
    AppUserDefaults.save(value: user.first_name, forKey: .firstName)
    AppUserDefaults.save(value: user.last_name, forKey: .lastName)
    AppUserDefaults.save(value: user.gender?.stringValueOfGender ?? "", forKey: .gender)
    AppUserDefaults.save(value: user.email, forKey: .email)
    AppUserDefaults.save(value: user.imageUrl, forKey: .userImage)
    AppUserDefaults.save(value: user.age, forKey: .age)
    AppUserDefaults.save(value: user.dob?.toString(dateFormat: "MM/dd/yyyy") ?? "", forKey: .dob)
    AppUserDefaults.save(value: user.user_id, forKey: .userId)
    AppUserDefaults.save(value: user.token, forKey: .Accesstoken)
    AppUserDefaults.save(value: user.otp_varified, forKey: .otpVarified)
    AppUserDefaults.save(value: user.importedList, forKey: .isPlaylistImported)
    AppUserDefaults.save(value: user.tidal_session_id, forKey: .tidal_session_id)
    AppUserDefaults.save(value: user.tidal_user_id, forKey: .tidal_user_id)
    AppUserDefaults.save(value: user.tidal_countryCode, forKey: .tidal_countryCode)
    
}


extension UIButton{
    
//    func rotateBackImage(){
//        
//        if sharedAppdelegate.appLanguage == .Arabic{
//            self.setImage(#imageLiteral(resourceName: "icMainPageGointo").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
//        }else{
//
//        }
//    }
    
}
