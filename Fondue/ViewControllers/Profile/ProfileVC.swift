//
//  ProfileVC.swift
//  Fondue
//
//  Created by Nanak on 24/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class ProfileVC: BaseVc {

    var userPlayLists = [PlayListModel]()
    var userDetail : User!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var playListTableview: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collaboratoreLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialSetup()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    func initialSetup(){
        
        let userid = userDetail.user_id ?? ""
        let cur_user_id = sharedAppDelegate.currentuser.userID
        
        if userid == cur_user_id{
            self.followBtn.isHidden = true
        }
        self.playListTableview.delegate = self
        
        self.playListTableview.dataSource = self
        
        self.playListTableview.tableFooterView = UIView(frame: CGRect.zero)
        
        self.profileImage.imageFromURl(self.userDetail.imageUrl)
        self.navigationTitleLbl.text = self.userDetail.displayName
        
        self.followersLbl.font = AppFonts.Seravek_Regular.withSize(14)
        self.collaboratoreLbl.font = AppFonts.Seravek_Regular.withSize(14)
        self.navigationTitleLbl.font = AppFonts.Seravek_Medium.withSize(17)
        self.getPlayList()
        
    }
    
    private func getPlayList(){
        
        var params = JSONDictionary()
        params["token"] = CurrentUser.accessToken ?? ""
        params["user_id"] = CurrentUser.user_id ?? ""

        
        WebServices.getUserPlaylistAPI(parameters: params, webServiceSuccess: { (success, msg, json) in
            AppNetworking.removeLoader()
            if success{
                self.userPlayLists = json.map({ (playlist) -> PlayListModel in
                    PlayListModel(data: playlist)
                })
                showNodata(self.userPlayLists, tableView: self.playListTableview, msg: "No playlist available", color: UIColor.white)
                
                self.playListTableview.reloadData()
            }else{
                showToastWithMessage(msg)
            }
        }) { (err) -> (Void) in
            AppNetworking.removeLoader()
            
            showToastWithMessage(err.localizedDescription)
        }
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
        
    }
    
    @IBAction func followBtnTAp(_ sender: UIButton) {
        
    }
}


//MARK:- UITabelview delegate and datasource Method
//MARK:- ==================


extension ProfileVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userPlayLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPlayListCell", for: indexPath) as! UserPlayListCell
        cell.populate(with: self.userPlayLists[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = self.userPlayLists[indexPath.row]
        NavigationManager.gotoPlayListDetail(from: self, playListDetail: selectedData)

    }
    
}



//MARK:- UITabelview cell classess
//MARK:- ==================


class UserPlayListCell: UITableViewCell {
    
    @IBOutlet weak var playListName: UILabel!
    @IBOutlet weak var firstFollowerImg: UIImageView!
    @IBOutlet weak var secondFollowerImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.playListName.font = AppFonts.Seravek_Regular.withSize(15)
    }
    
    func populate(with playlist : PlayListModel){
        
        self.playListName.text = playlist.title
        
        self.firstFollowerImg.imageFromURl(playlist.userDetail.imageUrl, placeHolderImage: #imageLiteral(resourceName: "if_apple-music-2_2301791"), loader: false) { (success) in
            
        }
        
        self.secondFollowerImg.imageFromURl(playlist.userDetail.imageUrl, placeHolderImage: #imageLiteral(resourceName: "if_apple-music-2_2301791"), loader: false) { (success) in
            
        }

    }
}



//owner =             {
//    "__v" = 0;
//    "_id" = 5ae013be06aa8f635f8e4786;
//    "access_token" = "";
//    "alternative_email" =                 (
//    );
//    "app_version" = "";
//    "apple_id" = "";
//    "birth_year" = 0;
//    city = "";
//    country = "";
//    "country_code" = "+91";
//    createDate = "2018-04-25T05:35:58.822Z";
//    createdAt = "2018-04-25T05:35:58.844Z";
//    "deezer_id" = "";
//    "device_model" = iPhone;
//    "device_token" = DummyDeviceToken;
//    "device_type" = "";
//    dob = "1970-01-01T00:00:00.000Z";
//    "dob_ms" = 0;
//    "fb_id" = "";
//    "first_name" = "";
//    importedList = 1;
//    industry = "";
//    "ip_address" = "";
//    "language_spoken" =                 (
//    );
//    languages = "";
//    "last_name" = "";
//    "lived_in_city" = "";
//    "mobile_number" = "";
//    "mobile_verified" = 0;
//    "network_type" = "";
//    "os_version" = "11.2";
//    otp = "";
//    "otp_set_time" = 0;
//    "otp_varified" = 0;
//    "otp_varified_time" = 0;
//    password = "";
//    "profile_status" = 0;
//    "session_start_time" = "2018-04-25T05:35:58.822Z";
//    sex = "";
//    source = tidal;
//    "spotify_id" = "";
//    state = "";
//    status = 2;
//    "tidal_password" = "Morgan88!";
//    "tidal_user_id" = 44198981;
//    "tidal_user_name" = "corey@revelationmgmt.com";
//    updatedAt = "2018-04-25T05:36:03.432Z";
//    "user_image" = "";
//    "user_type" = 1;
//    "verify_phone_otp" = false;
//    "zip_code" = "";
//}

