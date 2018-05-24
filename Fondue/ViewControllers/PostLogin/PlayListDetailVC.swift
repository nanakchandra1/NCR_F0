//
//  PlayListDetailVC.swift
//  Fondue
//
//  Created by Nanak on 18/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class PlayListDetailVC: BaseVc  {
    
    
    //MARK:- Properties
    //MARK:- ==========================
    
    var listNameArray : [String] = [StringConstants.Message , StringConstants.Snapchat , StringConstants.Messenger , StringConstants.Facebook , StringConstants.WhatsApp , StringConstants.Copy_Link]
    
    var imageArray : [UIImage] = [#imageLiteral(resourceName: "icPlaylistSharePageMessage"),#imageLiteral(resourceName: "icPlaylistSharePageSnapchat"),#imageLiteral(resourceName: "icPlaylistSharePageMessanger"),#imageLiteral(resourceName: "icPlaylistSharePageFacebook"),#imageLiteral(resourceName: "icPlaylistSharePageWhatsapp"),#imageLiteral(resourceName: "icPlaylistSharePageLink")]
    var playListDetail :PlayListModel!
    var playListName = ""
    var playlistTracksArray = [TracksModel]()

    //MARK:- IBOutlets
    //MARK:- ==========================
    
    @IBOutlet weak var playlistDetailTableView: UITableView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK:- View life cycle methods
    //MARK:- ==========================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBActions
    //MARK:- ==========================
    
    @IBAction func backBtnTApp(_ sender: UIButton) {
        
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
    }
}

//MARK:- Private Functions
//MARK:- ==========================

extension PlayListDetailVC{
    
    private func initialSetUp(){
        
        self.playlistDetailTableView.delegate = self
        self.playlistDetailTableView.dataSource = self
        self.playlistDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationTitleLbl.text = self.playListDetail.title
        self.getPlayListTracks()
    }
    
    private func getPlayListTracks(){
        
        var params = JSONDictionary()
        
        params["token"] = CurrentUser.accessToken
        
        params["playlist"] = self.playListDetail.playlistId
        
        WebServices.getPlaylistTracksAPI(parameters: params, webServiceSuccess: { (success, msg, json) in
            
            if success{
                
                self.playlistTracksArray = json.map({ (track) -> TracksModel in
                    TracksModel(data: track)
                })
                
                self.playlistDetailTableView.reloadData()
                
            }else{
                
                showToastWithMessage(msg)
                
            }
        }) { (err) -> (Void) in
            showToastWithMessage(err.localizedDescription)
        }
    }
}

//MARK:- UITableview delegate and datasource methods
//MARK:- ==========================

extension PlayListDetailVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
            
        }else{
            return self.playlistTracksArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            
            return 220
            
        }else{
            
            return 50
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PalylistDetailHeaderCell", for: indexPath) as! PalylistDetailHeaderCell
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistDetailSongsCell", for: indexPath) as! PlaylistDetailSongsCell
            let data = self.playlistTracksArray[indexPath.row]
            cell.populateData(with: data.image, title: data.title)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else{return}
        
//        let obj = PlayerVC.instantiate(fromAppStoryboard: .Player)
//        obj.trackInfo = self.playlistTracksArray[indexPath.row]
//        sharedAppDelegate.parentNavigationController.pushViewController(obj, animated: true)
        
    }
}

//MARK:- Cell Classess
//MARK:- ==========================

class PalylistDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var bgIamge: UIImageView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var firstUserImg: UIImageView!
    @IBOutlet weak var secondUserImg: UIImageView!
    @IBOutlet weak var thirdUserImg: UIImageView!
    @IBOutlet weak var followersCountLbl: UILabel!
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
    }
    
    
}

class PlaylistDetailSongsCell: UITableViewCell {
    
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackNameLbl: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.trackNameLbl.font = AppFonts.Seravek_Regular.withSize(15)
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
    }
    
    func populateData( with image : String , title : String){
        
        self.trackNameLbl.text = title.localized
        
        self.trackImage.imageFromURl(image, placeHolderImage: #imageLiteral(resourceName: "if_apple-music-2_2301791"), loader: false) { (success) in
            
        }
        
    }
}

