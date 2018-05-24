//
//  CollaboratorsVC.swift
//  Fondue
//
//  Created by Nanak on 24/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class CollaboratorsVC: UIViewController {

    var collaboratorsList = JSONDictionaryArray()
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var collaboratorsTableView: UITableView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var inviteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backBtnTapp(_ sender: UIButton) {
    
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
    }
    
    @IBAction func inviteBtnTap(_ sender: UIButton) {
        
    }
    
    func initialSetup(){
        
        self.collaboratorsTableView.delegate = self
        self.collaboratorsTableView.dataSource = self
        self.collaboratorsTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.searchBar.setPlaceHolder(with: StringConstants.Who_Are_Your_Collaborators.localized, with: AppColors.themeColor)
        self.inviteBtn.setTitle(StringConstants.Invite_your_friends.localized, for: .normal)
        self.searchBar.font = AppFonts.Seravek_Regular.withSize(17)
        
    }

}


//MARK:- UITabelview delegate and datasource Method
//MARK:- ==================


extension CollaboratorsVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//self.collaboratorsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorsCell", for: indexPath) as! CollaboratorsCell
        return cell
    }
}

//MARK:- UITabelview cell class
//MARK:- ==================

class CollaboratorsCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}


//{
//    birthday = "0000-00-00";
//    country = IN;
//    firstname = Kunal;
//    gender = "";
//    id = 1932558046;
//    "inscription_date" = "2018-01-18";
//    "is_kid" = 0;
//    lang = EN;
//    lastname = Nischal;
//    link = "https://www.deezer.com/profile/1932558046";
//    name = "Kunal Nischal";
//    picture = "https://api.deezer.com/user/1932558046/image";
//    "picture_big" = "https://e-cdns-images.dzcdn.net/images/user/91175383bbbdae71d4d5b7d14b0e8470/500x500-000000-80-0-0.jpg";
//    "picture_medium" = "https://e-cdns-images.dzcdn.net/images/user/91175383bbbdae71d4d5b7d14b0e8470/250x250-000000-80-0-0.jpg";
//    "picture_small" = "https://e-cdns-images.dzcdn.net/images/user/91175383bbbdae71d4d5b7d14b0e8470/56x56-000000-80-0-0.jpg";
//    "picture_xl" = "https://e-cdns-images.dzcdn.net/images/user/91175383bbbdae71d4d5b7d14b0e8470/1000x1000-000000-80-0-0.jpg";
//    status = 0;
//    tracklist = "https://api.deezer.com/user/1932558046/flow";
//    type = user;
//}

