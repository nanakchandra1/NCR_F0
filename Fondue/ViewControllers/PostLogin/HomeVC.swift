//
//  HomeVC.swift
//  Onboarding
//
//  Created by macOS on 13/02/18.
//  Copyright © 2018 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SKPhotoBrowser

class HomeVC: BaseVc {

   
    //MARK:- Properties
    //==================
    var gradientLayer: CAGradientLayer!
    var homeModelArray =  [PlayListModel]()
    var playlistTracksArray = [TracksModel]()
    var selectedIndexPath : IndexPath!
    var color = [AppColors.parrotGreenColor, AppColors.blueColor, AppColors.orangeColor, AppColors.pinkColor, AppColors.ylwColor]
    var activityIndicator : UIActivityIndicatorView!

    //MARK:- IBOutlet
    //===============
    @IBOutlet weak var logoutBtn: UIButton!

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()

    }
    
    
    override func didReceiveMemoryWarning() {
        
        print_debug("memory issues \(self)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.createGradientLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initialSetup() {
        
        AppNetworking.addLoader()
        getPlayList()
        self.navTitleLabel.font = AppFonts.Seravek.withSize(18)
        self.view.backgroundColor = AppColors.lightBlueColor
        self.homeTableView.backgroundColor  = AppColors.lightthemeColor
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        self.homeTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.logoutBtn.isHidden = true
        self.navTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTable), name: Notification.Name("reloadTable"), object: nil)
    }
    
    @objc func reloadTable(){
        self.homeTableView.reloadData()
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: self.navigationView.frame.minY, width: self.view.frame.width, height: 30)
        print_debug(self.navigationView.frame.minY)
        
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.34).cgColor, UIColor.black.withAlphaComponent(0.30).cgColor, UIColor.black.withAlphaComponent(0.28).cgColor, UIColor.black.withAlphaComponent(0.25).cgColor, UIColor.black.withAlphaComponent(0.20).cgColor, UIColor.black.withAlphaComponent(0.18).cgColor, UIColor.black.withAlphaComponent(0.15).cgColor, UIColor.black.withAlphaComponent(0.12).cgColor , UIColor.black.withAlphaComponent(0.1).cgColor]
            gradientLayer.locations = [0.0, 0.2, 0.4, 0.5]
           self.view.layer.addSublayer(gradientLayer)
    }
    
    func viewImageInMultipleImageViewer() {
        
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
        
    }

    
    private func getPlayList(){
        
        var params = JSONDictionary()
        params["token"] = CurrentUser.accessToken
        
        WebServices.getPlaylistAPI(parameters: params, webServiceSuccess: { (success, msg, json) in
            AppNetworking.removeLoader()
            
            if success{
                
                self.homeModelArray = json.map({ (playlist) -> PlayListModel in
                    
                    PlayListModel(data: playlist)

                })
                
                showNodata(self.homeModelArray, tableView: self.homeTableView, msg: "No playlist available", color: UIColor.white)

                self.homeTableView.reloadData()
            }else{
                showToastWithMessage(msg)
            }
        }) { (err) -> (Void) in
            AppNetworking.removeLoader()

        showToastWithMessage(err.localizedDescription)
        }
    }
    
    
    private func getPlayListTracks(with playlistId : String){
        
        var params = JSONDictionary()
        
        params["token"] = CurrentUser.accessToken
        
        params["playlist"] = playlistId
        
        WebServices.getPlaylistTracksAPI(parameters: params, webServiceSuccess: { (success, msg, json) in
            
            if success{
                
                self.playlistTracksArray = json.map({ (track) -> TracksModel in
                    TracksModel(data: track)
                })
                
                self.homeTableView.reloadData()
                
            }else{
                
                showToastWithMessage(msg)
                
            }
        }) { (err) -> (Void) in
            showToastWithMessage(err.localizedDescription)
        }
    }

    //MARK:- IBActions
    //================
    
    @IBAction func logoutBtnTap(_ sender: UIButton) {
        
        guard let token = CurrentUser.accessToken, !token.isEmpty else{return}
        
        WebServices.logOutAPI(parameters: ["token" : token], webServiceSuccess: { (success, msg, json) in
            
            if success{
                logOut()
            }
        }) { (err) -> (Void) in
            showToastWithMessage(err.localizedDescription)
        }
    }
}

//MARK:- SKPhotobrowser delegate methods
//=====================

extension HomeVC : SKPhotoBrowserDelegate {
    
    func createWebPhotos() -> [SKPhotoProtocol] {
        
        let image = self.homeModelArray[self.selectedIndexPath.row].image
        let images: [String] = [image]
        
        return (0..<images.count).map { (i: Int) -> SKPhotoProtocol in
            
            let photo = SKPhoto.photoWithImageURL(image, holder: #imageLiteral(resourceName: "icMainPageBg"))
            
            photo.caption = ""
            photo.shouldCachePhotoURLImage = false
            return photo
        }
    }
}


//MARK:- Target Methods
//=====================

extension HomeVC {
    
    @objc func forwardBtnTapped(sender: UIButton) {
        
    }
    
    @objc func userBtnTapped(sender: UIButton) {
        
//        guard let indexPath = sender.tableViewIndexPath(self.homeTableView) else {
//            return
//        }
//        
//        let userDetail = self.homeModelArray[indexPath.row].userDetail
//        
//        let obj = ProfileVC.instantiate(fromAppStoryboard: .Profile)
//        
//        obj.userDetail = userDetail
//        
//        sharedAppDelegate.parentNavigationController.pushViewController(obj, animated: true)
        
    }

    
    @objc func playBtnTapped(sender: UIButton) {
//        guard let indexPath = sender.tableViewIndexPath(self.homeTableView) else{return}
//        self.getPlayListTracks(with: indexPath)
    }
}


//MARK:- table View Delegate and Datasource
//===========================================

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListCell") as? PlayListCell else { fatalError("invalid cell") }
    
        
        cell.populateCell(with: indexPath,playlist: self.homeModelArray[indexPath.row])

        cell.forwardBtn.addTarget(self, action: #selector(self.forwardBtnTapped(sender:)), for: .touchUpInside)
        cell.userBtn.addTarget(self, action: #selector(self.userBtnTapped(sender:)), for: .touchUpInside)

        cell.playBtn.addTarget(self, action: #selector(self.playBtnTapped(sender:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth / 3
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedIndexPath = indexPath
        
//        self.viewImageInMultipleImageViewer()
        
//        let selectedData = self.homeModelArray[indexPath.row]
//        let user = selectedData.userDetail
//        let playlistID = selectedData.playlistId
//        print_debug(selectedData.userDetail.email)
//        NavigationManager.gotoPlayListDetail(from: self, playListDetail: selectedData)
        
        
//        var params = JSONDictionary()
//        params["userId"] = user.user_id
//        params["firstName"] = user.first_name
//        params["lastName"] = user.last_name
//        params["deviceToken"] = "123456"
//        let json = JSON(params)
//        let chatMember = ChatMember(with: json)
//
//
//        let userId = selectedData.userDetail.user_id ?? ""
//
//        let cur_userId = sharedAppDelegate.currentuser.userID
//
//        if userId != cur_userId{
//
//            NavigationManager.moveToSingleChat(from: self , senderId: userId, chatMember: chatMember)
//
//        }
    }
}

//MARK:- PrototypeCell
//======================
class PlayListCell: UITableViewCell {
    
    //MARK:- Properties
    //==================
    
    //MARK:- IBOutlet
    //===============
    
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var currentPlayingView: UIView!
    @IBOutlet weak var currentPlayingLabel: UILabel!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var thumbnail1: UIImageView!
    @IBOutlet weak var thumbnail2: UIImageView!
    @IBOutlet weak var thumbnail3: UIImageView!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.currentPlayingView.isHidden = true
        self.currentPlayingLabel.isHidden = true
        self.currentPlayingView.roundCorners()
        self.currentPlayingLabel.text = "Currently playing"
        self.playListNameLabel.font = AppFonts.Seravek_Medium.withSize(18.0)
        self.currentPlayingView.backgroundColor = AppColors.skyBlueColor
        self.playListNameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)

    }
    
    
    func populateCell(with indexPath : IndexPath , playlist : PlayListModel){
        
        
        self.playListNameLabel.text = playlist.title.uppercased()
        let tracks = playlist.tracks
        
        switch playlist.tracks.count {
            
        case 0:
            
            self.thumbnail1.image = #imageLiteral(resourceName: "bg_thumbnail1")
            self.thumbnail2.image = #imageLiteral(resourceName: "bg_thumbnail2")
            self.thumbnail3.image = #imageLiteral(resourceName: "bg_thumbnail3")

            break
            
        case 1:
            
            self.thumbnail1.imageFromURl(tracks.first!.image)
            self.thumbnail2.image = #imageLiteral(resourceName: "bg_thumbnail2")
            self.thumbnail3.image = #imageLiteral(resourceName: "bg_thumbnail3")

        case 2:
            
            self.thumbnail1.imageFromURl(tracks.first!.image)
            self.thumbnail2.imageFromURl(tracks[1].image)
            self.thumbnail3.image = #imageLiteral(resourceName: "bg_thumbnail3")

        default:
            
            self.thumbnail1.imageFromURl(tracks.first!.image)
            self.thumbnail2.imageFromURl(tracks[1].image)
            self.thumbnail3.imageFromURl(tracks[2].image)

        }
    }
}

//MARK:- PrototypeCell
//======================
class PlayListWithMultipleImageCell: UITableViewCell {
    
    //MARK:- Properties
    //==================
    
    //MARK:- IBOutlet
    //===============
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func populateCell(with indexPath : IndexPath , trcks : [TracksModel]){
        
        if indexPath.row == 0{
            
            self.firstImage.imageFromURl(trcks.first!.image)
            self.secondImage.imageFromURl(trcks[1].image)
            self.thirdImage.imageFromURl(trcks[2].image)

        }else{
            
        let imageView = UIImageView()
        
        imageView.imageFromURl("https://e-cdns-images.dzcdn.net/images/cover/dfe2bbacb53721456c37a7175121fd99/1000x1000-000000-80-0-0.jpg", placeHolderImage: nil, loader: false) { (isLoad) in
            if isLoad{
                
                let image : UIImage = imageView.image!
                let images : [UIImage] = image.matrix(2, 2)
                self.firstImage.image = images.first!
                self.secondImage.image = images[1]
                self.thirdImage.image = images[2]

            }
        }
        }
    }
}
