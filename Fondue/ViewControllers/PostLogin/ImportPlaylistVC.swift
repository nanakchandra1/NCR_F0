//
//  ImportPlaylistVC.swift
//  Onboarding
//
//  Created by macOS on 13/02/18.
//  Copyright © 2018 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import MediaPlayer
import SKPhotoBrowser

class ImportPlaylistVC: BaseVc {
    
    //MARK:- Properties
    //==================
    
    var importPlaylistModelArray    =  [ImportPlaylistModel]()
    let color                       =  [AppColors.lightSkyBlueColor, AppColors.greenishBlueColor]
    
    var spotifyPlayListArray = [SpotifyPlayListModel]()
    var spotifyPlayListTrackArray = [SpotifyTracksModel]()
    
    var tidalPlayList  = [TidelPlayListModel]()
    var tidalPlayListTracks  = [TidelPlayListTrackModel]()
    
    var deezerPlayListArray = [DeezerPlaylistModel]()
    var deezerTrackListArray = [DeezerTracklistModel]()
    
    
    var selectedIndexPath = [IndexPath]()
    var selectedDSP : SelectedDSPs = .Spotify
    var state : DSPSState = .signUp
    var timer:Timer?
    var isImported = false
    var array = [MPMediaItemCollection]()
    var filteredArray = [MPMediaItem]()
    var selectedMediaItem:MPMediaItem?
    var selectedPlaylists = JSONDictionaryArray()
    var selectedImage = ""
    var rowCount = 0
    
    //MARK:- IBOutlet
    //===============
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var importPlaylistTableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var noPlaylistLbl: UILabel!
    
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print_debug("memory issues \(self)")
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK:- IBActions
    //================
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        
        AppUserDefaults.removeAllValues()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnTap(_ sender: UIButton) {
        
        for res in self.selectedPlaylists{
            self.addPlayListService(with: res)
        }
    }
}

//MARK:- Private methods
//================

extension ImportPlaylistVC {
    
    private func initialSetup() {
        
        self.noPlaylistLbl.isHidden = true
        self.navTitleLabel.text = StringConstants.Import_playlist_Title.localized.uppercased()
        self.nextBtn.setTitle(StringConstants.NEXT.localized.capitalized, for: .normal)
        self.nextBtn.isHidden = true
        self.navTitleLabel.font = AppFonts.Seravek_Medium.withSize(18)
        self.nextBtn.titleLabel?.font = AppFonts.Seravek_Regular.withSize(16.0)
        self.navigationView.backgroundColor = AppColors.importPlaylistDarkBlueColor
        self.navTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)

        
        switch self.selectedDSP {
            
        case .Spotify:
            
            
            self.rowCount = self.spotifyPlayListArray.count
            
        case .Deezer:
            
            self.rowCount = self.deezerPlayListArray.count
            
        case .AppleMusic:
            
            self.rowCount = self.array.count
            
        case .Tidel:
            
            self.rowCount = self.tidalPlayList.count
        }
        
        
        self.importPlaylistTableView.delegate   = self
        self.importPlaylistTableView.dataSource = self
        self.initializeDSPs()
        
        
        
        
    }
    
    
    private func initializeDSPs(){
        
        switch self.selectedDSP {
            
        case .Spotify:
            self.importPlaylistTableView.reloadData()
            self.getPlayListFromSpotify()
        case .Deezer:
            self.loadDeezerSession()
        case .AppleMusic:
            self.getMediaLibraryData()
        case .Tidel:
            self.getTidalPlayList()
        }
    }
    
    private func checkIfPlaylistSelected(){
        
        if self.selectedIndexPath.isEmpty{
            self.nextBtn.isHidden = true
        }else{
            self.nextBtn.isHidden = false
        }
    }
}

//MARK:- SKPhotobrowser delegate methods
//=====================

extension ImportPlaylistVC : SKPhotoBrowserDelegate {
    
    func viewImageInMultipleImageViewer() {
        
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
        
    }

    func createWebPhotos() -> [SKPhotoProtocol] {
        
        let image = self.selectedImage
        let images: [String] = [image]
        
        return (0..<images.count).map { (i: Int) -> SKPhotoProtocol in
            
            let photo = SKPhoto.photoWithImageURL(image, holder: nil)
            
            photo.caption = ""
            photo.shouldCachePhotoURLImage = false
            return photo
        }
    }
}


//MARK:- UITableview delegate datasource methods
//================

extension ImportPlaylistVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            
            let rowsHeight = CGFloat(self.rowCount * 50)
            if rowsHeight >= screenHeight{
                return 0
            }else{
                
                var rows = 0
                if self.rowCount != 0{
                    
                    let remainingHeight = screenHeight - rowsHeight
                    rows = Int(remainingHeight) / 50
                    
                }
                return rows
            }
        }
        
        return self.rowCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.section == 0 else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImportPlaylistCell") as! ImportPlaylistCell
            if rowCount % 2 == 0{
                
                cell.backgroundColor = self.color[indexPath.row % 2]
                
            }else{
                
                cell.backgroundColor = self.color.reversed()[indexPath.row % 2]
                
            }
            
            cell.playlistNameLabel.textColor = UIColor.clear
            cell.playlistImageView.isHidden = true
            cell.selectPlaylistBtn.isHidden = true
            cell.showImageBtn.isHidden = true
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImportPlaylistCell") as? ImportPlaylistCell else { fatalError("invalid cell") }
        
        cell.playlistImageView.isHidden = false
        cell.selectPlaylistBtn.isHidden = false
        cell.showImageBtn.isHidden = false

        cell.showImageBtn.addTarget(self, action: #selector(self.showImageBtnTap(_:)), for: .touchUpInside)

        if self.selectedIndexPath.contains(indexPath){
            cell.selectPlaylistBtn.setImage(#imageLiteral(resourceName: "icImportPlaylistsPageCheckbox"), for: .normal)
            
        }else{
            cell.selectPlaylistBtn.setImage(#imageLiteral(resourceName: "icImportPlaylistsPageUncheckbox"), for: .normal)
        }
        
        switch self.selectedDSP {
            
        case .Spotify:
            
            if !self.spotifyPlayListArray.isEmpty{
                
                let data = self.spotifyPlayListArray[indexPath.row]
                cell.populateSpotifyData(with:data)
                
            }
            
        case .Deezer:
            
            if !self.deezerPlayListArray.isEmpty{
                
                let deezerObject = self.deezerPlayListArray[indexPath.row]
                cell.populateDeezerData(with: deezerObject)
                
            }
            
        case .AppleMusic:
            if !self.array.isEmpty{
                
                let item = self.array[indexPath.row]
                cell.populateAppleMusicData(with: item)
                
            }
        case .Tidel:
            
            if !self.tidalPlayList.isEmpty{
                
                cell.populateTidalData(with: self.tidalPlayList[indexPath.row])
                
            }
        }
        
        cell.backgroundColor = self.color[indexPath.row % 2]
        
        if indexPath.row % 2 == 0{
            
            cell.playlistNameLabel.textColor = AppColors.importPlaylistDarkTextColor
            
        }else{
            
            cell.playlistNameLabel.textColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            return
        }
        
        AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
        
        switch self.selectedDSP {
            
        case .Spotify:
            
            let data = self.spotifyPlayListArray[indexPath.row]
            
            self.getPlayListTracksFromSpotify(with: data.tracklistUrl, indexPath: indexPath, completion: { (tracks) in
                
                self.prepareFotddSpotifyPlaylist(with: indexPath, tracks: tracks)
            })
            
        case .Deezer:
            
            let url  = self.deezerPlayListArray[indexPath.row].tracklistUrl
            self.getDeezerTracksList(with: url, indexPath: indexPath, completion: { (tracks) in
                self.prepareFotddDeezerPlaylist(with: indexPath, tracks: tracks)
            })
            
        case .AppleMusic:
            
            self.prepareFotddAppleMusicPlaylist(with: indexPath)
            
        case .Tidel:
            
            self.getTidalPlayListTracks(with: indexPath, completion: { (tracks) in
                
                self.prepareFotddTidelPlaylist(with: indexPath, tracks: tracks)
                
            })
            
        }
        
    }
    
    @objc func showImageBtnTap(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(self.importPlaylistTableView) else{return}
        switch self.selectedDSP {
            
        case .Spotify:
            
            let data = self.spotifyPlayListArray[indexPath.row]
            self.selectedImage = data.picture.largeImage
            
        case .Deezer:
            
            let data  = self.deezerPlayListArray[indexPath.row]
            self.selectedImage = data.picture_xl

        case .AppleMusic:
            
            self.selectedImage = ""

        case .Tidel:
            
            self.selectedImage = ""
        }
        
        if !self.selectedImage.isEmpty{
            self.viewImageInMultipleImageViewer()
        }
    }
}


//MARK:- Spotify Session methods
//================

extension ImportPlaylistVC {
    //
    
    func getPlayListFromSpotify(){
        
        guard let userId = SpotifyManager.shared.userID else{return}
        
        let accesToken = SpotifyManager.shared.session.accessToken!
        
        var header = [String : String]()
        
        header["Authorization"] = "Bearer \(String(describing: accesToken))"
        
        let url = "https://api.spotify.com/v1/users/\(userId)/playlists"
        
        
        WebServices.getSpotifyPlaylistAPI(url: url, header: header, webServiceSuccess: { (items) in
            
            print_debug(items)
            
            self.spotifyPlayListArray = items.map({ (item) -> SpotifyPlayListModel in
                
                SpotifyPlayListModel(with: item)
            })
            
            self.rowCount = self.spotifyPlayListArray.count
            self.importPlaylistTableView.reloadData()
        })
    }
    
    func getPlayListTracksFromSpotify(with url : String ,indexPath : IndexPath , completion : @escaping ((JSONDictionaryArray) -> Void)){
        
        //        guard let userId = SpotifyManager.shared.userID else{return}
        
        let accesToken = SpotifyManager.shared.session.accessToken!
        
        var header = [String : String]()
        
        header["Authorization"] = "Bearer \(String(describing: accesToken))"
        
        //        let url = "https://api.spotify.com/v1/users/\(userId)/playlists"
        
        
        WebServices.getSpotifyPlaylistAPI(url: url, header: header, webServiceSuccess: { (items) in
            
            print_debug(items.first)
            
            self.spotifyPlayListTrackArray = items.map({ (item) -> SpotifyTracksModel in
                
                SpotifyTracksModel(with: item)
                
            })
            
            let tracksDict = self.createSpotifyTracksParameters()
            
            completion(tracksDict)
            
        })
    }
    
    func createSpotifyTracksParameters() -> JSONDictionaryArray{
        
        var paramsArray = JSONDictionaryArray()
        
        for track in self.spotifyPlayListTrackArray{
            
            print_debug(track)
            
            var params = JSONDictionary()
            
            params["source"] = "spotify"
            params["source_id"] = track.id
            params["uri"] = track.uri
            params["artist"] = track.artist.name
            params["album"] = track.album.name
            params["title"] = track.name
            params["image"] = track.album.picture.largeImage
            params["duaration"] = track.duration_ms
            paramsArray.append(params)
            
        }
        
        return paramsArray
    }
    
    private func prepareFotddSpotifyPlaylist(with indexPath : IndexPath , tracks : JSONDictionaryArray){
        
        if self.selectedIndexPath.contains(indexPath){
            
            self.selectedIndexPath = self.selectedIndexPath.filter({$0 != indexPath})
            self.selectedPlaylists = self.selectedPlaylists.filter({($0["index"] as! Int) != indexPath.row})
            
        }else{
            
            self.selectedIndexPath.append(indexPath)
            
            
            let playList = self.spotifyPlayListArray[indexPath.row]
            
            
            var spotyFyJSON : JSONDictionary = [:]
            
            spotyFyJSON["source"] = "spotify"
            spotyFyJSON["index"] = indexPath.row
            spotyFyJSON["source_id"] = playList.id
            spotyFyJSON["image"] = playList.picture.largeImage
            spotyFyJSON["title"] = playList.title
            spotyFyJSON["tracks"] = tracks.toJSONString()//JSON(sonftracks)
            spotyFyJSON["token"] = CurrentUser.accessToken
            spotyFyJSON["uri"] = playList.uri
            
            self.selectedPlaylists.append(spotyFyJSON)
            
        }
        
        self.importPlaylistTableView.reloadData()
        self.checkIfPlaylistSelected()
        
        
    }
    
}


//MARK:- GET APPLE MUSIC PALYLIST
//MARK:- ======================================

extension ImportPlaylistVC{
    
    //MARK:- Private Methods
    //MARK:-
    
    @objc private func getMediaLibraryData(){
        
        
        //get songs from media library
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                
                let query = MPMediaQuery.playlists()
                
                guard let playlist = query.collections else{return}
                print_debug(playlist.last?.value(forKeyPath: MPMediaPlaylistPropertyName))
                self.array = playlist
                self.rowCount = playlist.count
                DispatchQueue.main.async {
                    
                    self.importPlaylistTableView.reloadData()
                }
                
            } else {
                // user did not authorize
            }
        }
    }
    
    private func prepareFotddAppleMusicPlaylist(with indexPath : IndexPath){
        
        if self.selectedIndexPath.contains(indexPath){
            
            self.selectedIndexPath = self.selectedIndexPath.filter({$0 != indexPath})
            self.selectedPlaylists = self.selectedPlaylists.filter({($0["index"] as! Int) != indexPath.row})
        }else{
            
            let item = self.array[indexPath.row]
            let name =     item.value(forKeyPath: MPMediaPlaylistPropertyName)
            
            var params : JSONDictionary = [:]
            params["source"] = "apple"
            params["token"] = CurrentUser.accessToken
            params["index"] = indexPath.row
            params["title"] = "\(String(describing: name!))"
            let track: JSONDictionaryArray = [["source" : "apple", "title" : "name"], ["title" : "name", "source" : "apple"]]
            params["tracks"] = track.toJSONString()
            self.selectedPlaylists.append(params)
            self.selectedIndexPath.append(indexPath)
            
            //        self.addPlayListService(with: params)
        }
        self.importPlaylistTableView.reloadData()
        self.checkIfPlaylistSelected()
        
    }
    
}

//MARK:- GET DEEZER MUSIC PALYLIST
//MARK:- ======================================


extension ImportPlaylistVC{
    
    private func loadDeezerSession(){
        
        if DeezerManager.sharedInstance.sessionState == .connected {
            
            self.getDeezerPalylists()
            return
        }
        
        DeezerManager.sharedInstance.loginResult = sessionDidLogin
        DeezerManager.sharedInstance.login()
        
    }
    
    
    func sessionDidLogin(result: ResultLogin) {
        
        switch result {
            
        case .success:
            
            self.getDeezerPalylists()
            
        case let .error(error):
            
            if let error = error, error.type == .noConnection {
                
                showToastWithMessage(error.localizedDescription)
                
            }
        case .logout:
            break
        }
    }
    
    
    func getDeezerPalylists(){
        
        guard let deezerOnnect = DeezerManager.sharedInstance.deezerConnect, let userId = deezerOnnect.userId  else {
            return
        }
        
        let url = "https://api.deezer.com/user/\(userId)/playlists"
        
        WebServices.getDeezerPlaylistAPI(url: url, webServiceSuccess: { (total, playLists) in
            
            print_debug(playLists)
            
            self.deezerPlayListArray = playLists.map({ (playList) -> DeezerPlaylistModel in
                
                DeezerPlaylistModel(with: playList)
                
            })
            showNodata(self.deezerPlayListArray, tableView: self.importPlaylistTableView, msg: "No playlist available", color: AppColors.themeColor)
            
            self.rowCount = playLists.count
            self.importPlaylistTableView.reloadData()
            
        }) { (err) -> (Void) in
            print_debug(err)
        }
    }
    
    
    func getDeezerTracksList(with url : String ,indexPath : IndexPath , completion : @escaping ((JSONDictionaryArray) -> Void)) {
        
        WebServices.getDeezerTracklistAPI(url: url, webServiceSuccess: { (total, playLists) in
            
            print_debug(playLists)
            
            self.deezerTrackListArray = playLists.map({ (playList) -> DeezerTracklistModel in
                
                DeezerTracklistModel(with: playList)
                
            })
            
            let tracksDict = self.createDeezerTracksParameters()
            completion(tracksDict)
            
        }) { (err) -> (Void) in
            print_debug(err)
        }
    }
    
    
    private func prepareFotddDeezerPlaylist(with indexPath : IndexPath , tracks : JSONDictionaryArray){
        
        if self.selectedIndexPath.contains(indexPath){
            
            self.selectedIndexPath = self.selectedIndexPath.filter({$0 != indexPath})
            self.selectedPlaylists = self.selectedPlaylists.filter({($0["index"] as! Int) != indexPath.row})
            
        }else{
            
            self.selectedIndexPath.append(indexPath)
            
            let data = self.deezerPlayListArray[indexPath.row]
            
            var params : JSONDictionary = [:]
            
            params["source"] = "deezer"
            params["title"] = data.title
            params["token"] = CurrentUser.accessToken
            params["image"] = data.picture_xl
            
            params["index"] = indexPath.row
            
            params["tracks"] = tracks.toJSONString()
            
            self.selectedPlaylists.append(params)
            
        }
        
        self.importPlaylistTableView.reloadData()
        self.checkIfPlaylistSelected()
        
    }
    
    
    func createDeezerTracksParameters() -> JSONDictionaryArray{
        
        var paramsArray = JSONDictionaryArray()
        
        for track in self.deezerTrackListArray{
            
            var params = JSONDictionary()
            
            params["source"] = "deezer"
            params["source_id"] = track.id
            params["artist"] = track.artist.name
            params["album"] = track.album.title
            params["title"] = track.title
            params["image"] = track.album.cover
            params["duaration"] = track.duaration
            paramsArray.append(params)
            
        }
        return paramsArray
    }
    
}


//MARK:- Tidalmusic
//MARK:- ========================================

extension ImportPlaylistVC {
    
    private func createURLFromParameters(parameters: [String:Any], pathparam: String?) -> String {
        
        var components = URLComponents()
        components.scheme = TidalConstants.APIDetails.APIScheme
        components.host   = TidalConstants.APIDetails.APIHost
        components.path   = TidalConstants.APIDetails.APIPath
        if let paramPath = pathparam {
            components.path = TidalConstants.APIDetails.APIPath + "\(paramPath)"
        }
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return (components.url?.absoluteString)!
    }
    
    
    private func createURLFromParametersForTracks(parameters: [String:Any], pathparam: String?, playlist: String) -> String {
        
        let path = TidalConstants.APIDetails.APIPathTrcak + "playlists/" + "\(playlist)" + "/"
        var components = URLComponents()
        components.scheme = TidalConstants.APIDetails.APIScheme
        components.host   = TidalConstants.APIDetails.APIHost
        components.path   = path
        if let paramPath = pathparam {
            components.path = path + "\(paramPath)"
        }
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return (components.url?.absoluteString)!
    }
    
    
    private func getTidalPlayList(){
        
        let url = createURLFromParameters(parameters: ["countryCode" : CurrentUser.tidal_countryCode!,"sessionId" : CurrentUser.tidal_session_id!], pathparam: "playlists")
        
        WebServices.getTidalPlaylistAPI(url: url, webServiceSuccess: { (limit, total, data) in
            
            self.tidalPlayList = data.map({ (playlist) -> TidelPlayListModel in
                
                TidelPlayListModel(data: playlist)
            })
            showNodata(self.tidalPlayList, tableView: self.importPlaylistTableView, msg: "No playlist available", color: AppColors.themeColor)
            self.rowCount = data.count
            self.importPlaylistTableView.reloadData()
            AppNetworking.hideLoader()
            
        }) { (err) -> (Void) in
            AppNetworking.hideLoader()
        }
    }
    
    
    private func getTidalPlayListTracks(with indexPath : IndexPath , completion : @escaping ((JSONDictionaryArray) -> Void)){
        
        
        let item =  self.tidalPlayList[indexPath.row]
        let uuid =  item.uuid
        
        let url = createURLFromParametersForTracks(parameters: ["countryCode" : CurrentUser.tidal_countryCode!,"sessionId" : CurrentUser.tidal_session_id!], pathparam: "tracks", playlist: uuid)
        
        WebServices.getTidalPlaylistAPI(url: url, webServiceSuccess: { (limit, total, data) in
            
            self.tidalPlayListTracks = data.map({ (playlist) -> TidelPlayListTrackModel in
                
                TidelPlayListTrackModel(data: playlist)
            })
            
            let tracksDict = self.createTidalTracksParameters()
            completion(tracksDict)

        }) { (err) -> (Void) in
            
        }
    }
    
    
    func createTidalTracksParameters() -> JSONDictionaryArray{
        
        var paramsArray = JSONDictionaryArray()
        
        for track in self.tidalPlayListTracks{
            
            var params = JSONDictionary()
            
            params["source"] = "tidal"
            params["source_id"] = track.id
            params["artist"] = track.artist.name
            params["album"] = track.album.title
            params["title"] = track.title
            params["image"] = track.album.cover
            params["duaration"] = track.duration
            paramsArray.append(params)
            
        }
        
        return paramsArray
        
    }
    
    
    private func addPlayListService( with parameters : JSONDictionary){
        
        WebServices.addPlaylistAPI(parameters: parameters, webServiceSuccess: { (success, msg, json) in
            
            if success{
                
                if !self.isImported{
                    
                    AppUserDefaults.save(value: true, forKey: .isPlaylistImported)
                    NavigationManager.gotoHome()
                    self.isImported = true
                }
            }
        }, failure: { (err) -> (Void) in
            showToastWithMessage(err.localizedDescription)
        })
    }
    
    private func prepareFotddTidelPlaylist(with indexPath : IndexPath , tracks : JSONDictionaryArray){
        
        if self.selectedIndexPath.contains(indexPath){
            
            self.selectedIndexPath = self.selectedIndexPath.filter({$0 != indexPath})
            self.selectedPlaylists = self.selectedPlaylists.filter({($0["index"] as! Int) != indexPath.row})
            
        }else{
            
            self.selectedIndexPath.append(indexPath)
            
            let item =  self.tidalPlayList[indexPath.row]
            let name =  item.title
            let uuid =  item.uuid
            
            var params : JSONDictionary = [:]
            
            params["source"] = "tidal"
            params["token"] = CurrentUser.accessToken
            params["source_id"] = uuid
            params["index"] = indexPath.row
            
            params["title"] = name
            
            params["tracks"] = tracks.toJSONString()
            
            self.selectedPlaylists.append(params)
            
        }
        
        self.importPlaylistTableView.reloadData()
        self.checkIfPlaylistSelected()
        
    }
    
}

//MARK:- PrototypeCell
//======================
class ImportPlaylistCell: UITableViewCell {
    
    //MARK:- Properties
    //==================
    
    //MARK:- IBOutlet
    //===============
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var selectPlaylistBtn: UIButton!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var showImageBtn: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.selectPlaylistBtn.roundCorners()
        self.playlistNameLabel.font = AppFonts.Seravek.withSize(14.7)
        self.playlistNameLabel.transform = CGAffineTransform(scaleX: 1, y: 1.2)

        
    }
    
    func populateSpotifyData(with data : SpotifyPlayListModel){

//        self.playlistNameLabel.text = data.title
        self.setCurning(with: data.title)
        let image = data.picture.self.largeImage
        self.playlistImageView.imageFromURl(image, placeHolderImage: #imageLiteral(resourceName: "if_apple-music-2_2301791"), loader: false) { (success) in
        }
    }
    
    func populateDeezerData(with data : DeezerPlaylistModel){
        

//        self.playlistNameLabel.text = data.title
        self.setCurning(with: data.title)

        let image = data.picture
        self.playlistImageView.imageFromURl(image, placeHolderImage: #imageLiteral(resourceName: "if_apple-music-2_2301791"), loader: false) { (success) in
            
        }
        
    }
    
    func populateAppleMusicData(with data : MPMediaItemCollection){
        
        
        let name =  data.value(forKeyPath: MPMediaPlaylistPropertyName)
        self.setCurning(with: "\(String(describing: name!))")
        
    }
    
    func populateTidalData(with data : TidelPlayListModel){
//        self.playlistNameLabel.text = data.title
        self.setCurning(with: data.title)
        let image = data.image

        self.playlistImageView.imageFromURl(image, placeHolderImage: #imageLiteral(resourceName: "if_apple-music-2_2301791"), loader: false) { (success) in
            
        }

    }
    
    func setCurning(with title : String){
        
        let attribute =
            [
                NSAttributedStringKey.kern: 1.2,
                ] as [NSAttributedStringKey : Any]
        
        self.playlistNameLabel.attributedText = NSAttributedString(string: title.capitalized, attributes: attribute)

    }
    
}



