//
//  PreSignupVC.swift
//  Onboarding
//
//  Created by macOS on 12/02/18.
//  Copyright © 2018 Gurdeep Singh. All rights reserved.
//

import UIKit
import MediaPlayer
import StoreKit
import SwiftyJSON

@objcMembers

class SignUpOptionVC: BaseVc {
    
    //MARK:- IBOutlet
    //===============
    @IBOutlet weak var makePlayListLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var listBgView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    //    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var listHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var signupBtnLbl: UILabel!
    
    //MARK:- Properties
    //=================
    
    var listArr = [["title": StringConstants.Spotify.localized, "id" : "1"],["title": StringConstants.Apple_Music.localized, "id" : "2"],["title": StringConstants.Tidal.localized, "id" : "3"],["title": StringConstants.Deezer.localized, "id" : "4"]]
    
    var selectedDsp : SelectedDSPs = .Spotify
    var isOpen = false
    var signupState = SignupOptionState.signUp
    
    /// The instance of `AuthorizationManager` used for querying and requesting authorization status.
    var authorizationManager :AuthorizationManager!
    
    /// The instance of `AuthorizationDataSource` that provides information for the `UITableView`.
    var authorizationDataSource: AuthorizationDataSource!
    
    /// A boolean value representing if a `SKCloudServiceSetupViewController` was presented while the application was running.
    
    var didPresentCloudServiceSetup = false
    
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove this line after check
        AppUserDefaults.removeAllValues()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    
    
    override func didReceiveMemoryWarning() {
        print_debug("memory issues \(self)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.isOpen = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isOpen = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .getAccessTokenNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AuthorizationManager.cloudServiceDidUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("presentAppleSubscriptionNotification"), object: nil)
        
    }
    
    
    
    
    //MARK:- Private Methods
    //======================
    
    private func initialSetup() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSpotifySession), name: .getAccessTokenNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAuthorizationManagerDidUpdateNotification),
                                               name: AuthorizationManager.cloudServiceDidUpdateNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentCloudServiceSetup), name: NSNotification.Name("presentAppleSubscriptionNotification"), object: nil)
        
        self.bgView.backgroundColor = AppColors.themeColor
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.makePlayListLabel.font = AppFonts.Seravek.withSize(20.0)
        self.makePlayListLabel.text = "MAKE PLAYLISTS WITH FRIENDS"
        self.makePlayListLabel.textColor = UIColor.white
        
        self.makePlayListLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        
        self.signupBtnLbl.font = AppFonts.Seravek.withSize(16)
        self.signupBtnLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)

        let attribute =
            [
                NSAttributedStringKey.kern: 1.2,
                ] as [NSAttributedStringKey : Any]

        self.signupBtnLbl.backgroundColor = UIColor.white

        self.signupBtnLbl.textColor = AppColors.btnTextGreenLightColor
        
        if self.signupState == .signUp{
            
            self.signupBtnLbl.attributedText = NSAttributedString(string: StringConstants.Sign_up.localized.capitalized.capitalized, attributes: attribute)

        }else{
            
            self.signupBtnLbl.attributedText = NSAttributedString(string: StringConstants.LOGIN.localized.capitalized.capitalized, attributes: attribute)

        }
        
        self.listHeightConstant.constant = 32
        
    }
    
    
    private func listShowHide( with height : CGFloat){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.listHeightConstant.constant = height
            self.view.layoutIfNeeded()
        })
    }
    
    private func openSelectedDsp(){
        
        let id = self.listArr.first!["id"]!
        
        switch id {
            
        case "1":
            
            self.loadSpotifySession()
            
        case "2":
            
            self.selectedDsp = .AppleMusic
//            NavigationManager.gotoImportPlayList(from: self, with: self.selectedDsp)

            self.authorizationManager = AuthorizationManager(appleMusicManager: AppleMusicManager())
            authorizationManager.requestCloudServiceAuthorization()
            authorizationManager.requestMediaLibraryAuthorization()
            
        case "3":
            
            self.selectedDsp = .Tidel
            NavigationManager.gotoTidalLogin(from: self)
            
        case "4":
            self.selectedDsp = .Deezer
            self.loadDeezerSession()
            
        default:
            
            fatalError("")
        }
    }
    
    
    private func DSPsLogin(with parameters : JSONDictionary){
        
        var params = parameters
        
        params["device_token"] = DeviceDetail.deviceToken
        params["device_id"] = DeviceDetail.device_id
        params["device_model"] = DeviceDetail.device_model
        params["os_version"] = DeviceDetail.os_version
        params["platform"] = "2"
        
        WebServices.signUpWithDSPsAPI(parameters: params, webServiceSuccess: { (success, msg, json) in
            
            if success{
                
                let userDetail = User(json: json)
                let user_id = userDetail.user_id ?? ""
                let email = "\(userDetail.user_id!)@gmail.com"
                let password = "1234567890"
                
                saveToUserDefault(userDetail)
                var params = JSONDictionary()
                params["userId"] = user_id
                params["firstName"] = email
                params["lastName"] = email
                params["deviceToken"] = "123456"
                let json = JSON(params)
                
                sharedAppDelegate.currentuser = ChatMember(with: json)

                if !self.isOpen{
                    self.isOpen = true
                    if !CurrentUser.isPlayListImported{

                        FirebaseHelper.createUser(email: email, password: password, completion: { (success) in
                            print_debug(success)
                        })
                        NavigationManager.gotoImportPlayList(from: self, with: self.selectedDsp)
                        
                    }else{
                        FirebaseHelper.authenticate(withEmail: email, password: password, completion: { (success) in
                            print_debug(success)
                        })
                        NavigationManager.gotoHome()
                    }
                }
            }else{
                showToastWithMessage(msg)
            }
        }) { (err) -> (Void) in
            showToastWithMessage(err.localizedDescription)
        }
    }
    
    
    //MARK:- IBActions
    //=================
    
    @IBAction func onTapListBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.listShowHide(with: 128)
        }else{
            self.listShowHide(with: 32)
        }
    }
    
    
    
    @IBAction func onTapSignupBtn(_ sender: UIButton) {
        
        self.listShowHide(with: 32)
        
        self.openSelectedDsp()
        
    }
    
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


extension SignUpOptionVC: SKCloudServiceSetupViewControllerDelegate {
    
    func cloudServiceSetupViewControllerDidDismiss(_ cloudServiceSetupViewController: SKCloudServiceSetupViewController) {
        DispatchQueue.main.async {
            //self.tableView.reloadData()
        }
    }
}


//MARK:- Tidal Session methods
//================

extension SignUpOptionVC: TidalLoginDelegate {
    
    func tidelLogin(isOpen: Bool) {
        
        if isOpen{
            
            let user_id = CurrentUser.user_id ?? ""
            let email = "\(user_id)@gmail.com"
            let password = "1234567890"
            
            var params = JSONDictionary()
            params["userId"] = user_id
            params["firstName"] = email
            params["lastName"] = email
            params["deviceToken"] = "123456"
            let json = JSON(params)
            
            sharedAppDelegate.currentuser = ChatMember(with: json)

            if !CurrentUser.isPlayListImported{
                
                FirebaseHelper.createUser(email: email, password: password, completion: { (success) in
                    print_debug(success)
                })

                NavigationManager.gotoImportPlayList(from: self, with: self.selectedDsp)
                
            }else{
                
                NavigationManager.gotoHome()
            }
            
        }
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.clear
        }
    }
}


//MARK:- Spotify Session methods
//================

extension SignUpOptionVC {
    
    private func loadSpotifySession() {
        
        SpotifyManager.shared.startSpotify()
    }
    
    
    @objc private func getSpotifySession(){
        
        let userId = SpotifyManager.shared.userID
        
        var params = JSONDictionary()

        params["dsp_id"] = userId
        params["source"] = "spotify"
        params["name"] = SpotifyManager.shared.userDetail["display_name"].stringValue
        params["user_name"] = SpotifyManager.shared.userDetail["email"].stringValue
        let image = SpotifyManager.shared.userDetail["images"].arrayValue
        if !image.isEmpty{
            params["user_image"] = image.first!["url"].stringValue
        }
        
        params["gender"] = ""
        params["dob"] = ""

        print_debug(params)
        
        self.DSPsLogin(with: params)
        
        
    }
}


//MARK:- Deezer Session methods
//================

extension SignUpOptionVC {
    
    private func loadDeezerSession(){
        
        deezerSharedInstance.logout()
        deezerSharedInstance.loginResult = sessionDidLogin
        deezerSharedInstance.login()
        
    }
    
    
    func sessionDidLogin(result: ResultLogin) {
        
        switch result {
            
        case .success:
            
            
            guard let deezerOnnect = deezerSharedInstance.deezerConnect, let userId = deezerOnnect.accessToken  else {
                return
            }

            print_debug(userId)
            
                if let token = CurrentUser.accessToken, !token.isEmpty{
                    NavigationManager.gotoImportPlayList(from: self, with: .Deezer)
                }else{
                    
                    var params = JSONDictionary()
                    params["dsp_id"] = userId
                    params["source"] = "deezer"
                    
                    params["name"] = deezerSharedInstance.userDetail["name"].stringValue
                    params["user_name"] = deezerSharedInstance.userDetail["id"].stringValue
                    params["user_image"] = deezerSharedInstance.userDetail["picture"].stringValue
                    params["gender"] = deezerSharedInstance.userDetail["gender"].stringValue
                    params["dob"] = ""

                    print_debug(params)
                    self.DSPsLogin(with: params)
                }
            
            print_debug("")
            
        case let .error(error):
            
            if let error = error, error.type == .noConnection {
                showToastWithMessage(error.localizedDescription)
            }
        case .logout:
            break
        }
    }
}


extension SignUpOptionVC{
    
    // MARK: SKCloudServiceSetupViewController Method
    
    func presentCloudServiceSetup() {
        
        AppNetworking.showLoader()
        
        let cloudServiceSetupViewController = SKCloudServiceSetupViewController()
        
        cloudServiceSetupViewController.delegate = self
        
        
        cloudServiceSetupViewController.load(options: [.action: SKCloudServiceSetupAction.subscribe]) { [weak self] (result, error) in
            AppNetworking.hideLoader()
            guard error == nil else {
                fatalError("An Error occurred: \(error!.localizedDescription)")
            }

            if result {
                
                DispatchQueue.main.async {

                    self?.present(cloudServiceSetupViewController, animated: true, completion: nil)
                    self?.didPresentCloudServiceSetup = true
                }
            }
        }
    }
    
    
    // MARK: Notification Observing Methods
    
    func handleAuthorizationManagerDidUpdateNotification() {
        
        DispatchQueue.main.async {
            
            AppNetworking.hideLoader()
            
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
            if self.authorizationManager.cloudServiceCapabilities.contains(.musicCatalogPlayback) || self.authorizationManager.cloudServiceCapabilities.contains(.addToCloudMusicLibrary){
                let deviceId = DeviceDetail.device_id + "fondue"
                var params = JSONDictionary()
                params["dsp_id"] = deviceId
                params["source"] = "apple"
                params["name"] = "apple"
                params["user_name"] = "applemusic"
                params["user_image"] = ""
                params["gender"] = ""
                params["dob"] = ""
                
                self.DSPsLogin(with: params)

            }else if self.authorizationManager.cloudServiceCapabilities.contains(.musicCatalogSubscriptionEligible){

                NavigationManager.showPopUP(selectedDSP: .AppleMusic, title: "Not a premium member", message: "For becoming premium member, use Apple Music for purchasing subscription.")

                }
            }
        }
    }
    
}


//MARK:- Tableview delegate datasource method
//=================

extension SignUpOptionVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DspsListCell", for: indexPath) as! DspsListCell
        cell.listLbl.text = self.listArr[indexPath.row]["title"]?.capitalized
        
        cell.listLbl.transform = CGAffineTransform(scaleX: 1.05, y: 1.2)
        cell.listLbl.font = AppFonts.Seravek_Light.withSize(16)
        
        let attribute =
            [
             NSAttributedStringKey.kern: 1.2,
             ] as [NSAttributedStringKey : Any]
        cell.listLbl.attributedText = NSAttributedString(string: self.listArr[indexPath.row]["title"]!.capitalized, attributes: attribute)

//        if indexPath.row == 0{
//            
//            cell.listLbl.backgroundColor = UIColor.white
//            cell.listLbl.textColor = AppColors.btnTextGreenLightColor
//            
//        }else{
//            
//            cell.listLbl.backgroundColor = AppColors.btnTextGreenLightColor
//            cell.listLbl.textColor = UIColor.white
//            
//        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            if self.listHeightConstant.constant == 128{
                self.listShowHide(with: 32)
            }else{
                self.listShowHide(with: 128)
            }
        }else{
            self.listShowHide(with: 32)
            self.listBtn.isSelected = !self.listBtn.isSelected
            self.listArr.swapAt(0, indexPath.row)
            self.listTableView.reloadData()
        }
    }
}


//MARK:- Tableview cell class
//=================

class DspsListCell: UITableViewCell {
    
    @IBOutlet weak var listLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.listLbl.font = AppFonts.Seravek.withSize(16.9)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    
    
    
}


