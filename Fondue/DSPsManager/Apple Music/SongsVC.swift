////
////  SongsVC.swift
////  Veme
////
////  Created by Sarthak Gupta on 12/05/16.
////  Copyright © 2016 AppInventiv. All rights reserved.
////
//
//import UIKit
//import MediaPlayer
//
//class SongsVC: BaseViewController {
//
//    //MARK:- IBOutlets
//    //MARK:-
//    @IBOutlet weak var tableV: UITableView!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var backButton: UIButton!
//
//
//    //MARK:- Local Properties
//    //MARK:-
//    weak var progressLbl: UILabel!
//    weak var totalDurationLbl: UILabel!
//    weak var progressView: UIProgressView?
//
//    var array = [MPMediaItem]()
//    var filteredArray = [MPMediaItem]()
//    var selectedMediaItem:MPMediaItem?
//    var isPlaying = false
//    var avplayer: AVPlayer!
//    var videoProgressTimer:Timer?
//    var timer:Timer?
//
//
//    //MARK:- View Controller Life Cycle
//    //MARK:-
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Globals.printlnDebug("view loaded \(self.className)")
//
//        //setup title label
//        self.titleLbl.text = "CHOOSE SONG".uppercased()
//        self.titleLbl.font = AppFonts.SegoeUI(17.0)
//        self.tableV.tableFooterView = UIView()
//
//        //setup search bar
//        self.searchBar.placeholder = "Search Music"
//        self.searchBar.delegate = self
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    deinit {
//        Globals.printlnDebug("Deallocated \(self.className)")
//    }
//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(animated)
//        if #available(iOS 9.3, *) {
//            //get songs form media library
//            MPMediaLibrary.requestAuthorization { (authorizationStatus:MPMediaLibraryAuthorizationStatus) in
//
//                switch (authorizationStatus) {
//                case MPMediaLibraryAuthorizationStatus.authorized:
//                    let query = MPMediaQuery.songs()
//                    query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
//                    let album = MPMediaQuery.albums()
//                    for so in (album.items ?? [MPMediaItem]()) {
//                        print("title = \(so.title ?? ""), album = \(so.albumTitle ?? "")")
//                    }
//                    if let items = query.items {
//                        self.array = items
//                        self.filterSongsArray("")
//                    }
//                default:
//                    break
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//            timer?.invalidate()
//            timer = nil
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SongsVC.getMediaLibraryData(_:)), userInfo: nil, repeats: true)
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        Globals.resignKeyBoard()
//        timer?.invalidate()
//        timer = nil
//        if self.avplayer != nil{
//            self.isPlaying = false
//            self.avplayer.pause()
//            self.avplayer = nil
//            self.endVideoTimer()
//        }
//    }
//
//
//
//    //MARK:- Private Methods
//    //MARK:-
//    @objc fileprivate func getMediaLibraryData(_ timer:Timer){
//
//        //get songs from media library
//        let query = MPMediaQuery.songs()
//        query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
//        if let items = query.items, self.array.count !=  items.count{
//            self.array = items
//            self.filterSongsArray("")
//        }
//    }
//
//    @objc fileprivate func playPause(_ sender: UIButton){
//        //play/pause the current player item
//        sender.isSelected = !sender.isSelected
//        self.isPlaying = sender.isSelected
//        if sender.isSelected{
//            self.avplayer.play()
//            self.startVideoTimer()
//        }else{
//            self.avplayer.pause()
//            self.endVideoTimer()
//        }
//    }
//
//    fileprivate func filterSongsArray(_ withText: String) {
//        //filter songs respect to search text
//        if withText.length > 0 {
//            self.filteredArray = self.array.filter { (songItem) -> Bool in
//                if #available(iOS 9.2, *) {
//                    return ((songItem.title ?? "").contains(withText) || (songItem.artist ?? "").contains(withText)) && !songItem.hasProtectedAsset
//                } else {
//                    return ((songItem.title ?? "").contains(withText) || (songItem.artist ?? "").contains(withText)) && (songItem.assetURL != nil)
//                }
//            }
//        }
//        else {
//            self.filteredArray = self.array.filter { (songItem) -> Bool in
//                if #available(iOS 9.2, *) {
//                    return !songItem.hasProtectedAsset
//                } else {
//                    return songItem.assetURL != nil
//                    // Fallback on earlier versions
//                }
//            }
//        }
//
//        Globals.getMainQueue {
//            let message = withText.length > 0 ? "No song with \(withText)" : "No song found"
//            self.tableV.addNoDataLable(self.filteredArray.count, withMessage: message, withFont: AppFonts.SegoeUI(13.0), textColor: UIColor.gray)
//            self.tableV.reloadData()
//        }
//    }
//
//
//    //MARK:- IBAction Methods
//    //MARK:-
//    @IBAction func cancelBtnAction(_ sender: UIButton) {
//        let navigationCont = self.navigationController as! MusicPickerNavigationController
//        navigationCont.musicPickerDelegate?.musicPicker(didCancelMusicPicker: navigationCont)
//    }
//}
//
//
////MARK:- Extension For Search Bar Delegate Methods
////MARK:-
//extension SongsVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.filterSongsArray(searchText)
//    }
//}
//
////MARK:- Extension For Table View Datasource and Delegate Methods
////MARK:-
//extension SongsVC: UITableViewDataSource , UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.filteredArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCell", for: indexPath) as! MediaCell
//        cell.selectionStyle = UITableViewCellSelectionStyle.default
//        let collection = self.filteredArray[indexPath.row]
//        cell.arrowIcon.addTarget(self, action: #selector(SongsVC.addBtnAction(_:)), for: UIControlEvents.touchUpInside)
//        cell.loadSongCell(collection)
//
//        if let item = self.selectedMediaItem, let index = self.filteredArray.index(of: item), index == indexPath.row {
//            cell.progresV.isHidden = false
//            cell.arrowIcon.isEnabled = true
//            cell.arrowIcon.isSelected = true
//            cell.playBtn.isSelected = self.isPlaying
//            cell.progressVHeightConstraint.constant = 36
//            self.progressLbl = cell.progressLbl
//            self.progressLbl.text = "00:00"
//            self.totalDurationLbl = cell.totalTimeLbl
//            self.progressView = cell.progressBar
//        }else{
//            cell.progresV.isHidden = true
//            cell.arrowIcon.isEnabled = false
//            cell.arrowIcon.isSelected = false
//            cell.progressVHeightConstraint.constant = 0
//        }
//        cell.playBtn.addTarget(self, action: #selector(SongsVC.playPause(_:)), for: UIControlEvents.touchDown)
//        cell.layoutIfNeeded()
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let item = self.selectedMediaItem, let index = self.filteredArray.index(of: item), index == indexPath.row {
//            return 88
//        }
//        else {
//            return 51
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        guard let feedCell = self.tableV.cellForRow(at: indexPath) as? MediaCell else{return}
//        if let item = self.selectedMediaItem, let index = self.filteredArray.index(of: item), index == indexPath.row {
//            let indexP = IndexPath(row: index, section: 0)
//            if self.tableV.isRowPresentAt(index: indexP){
//                if self.avplayer != nil{
//                    self.isPlaying = false
//                    self.avplayer.pause()
//                    self.endVideoTimer()
//                }
//                if indexP == indexPath{
//                    self.selectedMediaItem = nil
//                    self.progressLbl = nil
//                    self.totalDurationLbl = nil
//                    self.progressView = nil
//                    self.tableV.reloadData()
//                }
//                else{
//                    self.isPlaying = true
//                    self.selectedMediaItem = self.filteredArray[indexPath.row]
//                    self.tableV.reloadData()
//                    self.perform(#selector(SongsVC.loadPlayer), with: feedCell, afterDelay: 0.3)
//                }
//            }
//        }else{
//            self.isPlaying = true
//            self.selectedMediaItem = self.filteredArray[indexPath.row]
//            self.tableV.reloadData()
//            self.perform(#selector(SongsVC.loadPlayer), with: feedCell, afterDelay: 0.3)
//        }
//    }
//
//    func addBtnAction(_ sender: UIButton){
//        //select the song and send back
//        if let cell = self.tableV.cell(forItem: sender) as? MediaCell{
//            let indexPath = self.tableV.indexPath(for: cell)!
//            let item = self.filteredArray[indexPath.row];
//            let navigationCont = self.navigationController as! MusicPickerNavigationController
//            navigationCont.musicPickerDelegate?.musicPicker(navigationCont, didFinishPickingMusicURL: item.assetURL)
//        }
//    }
//
//    @objc fileprivate func loadPlayer(){
//        //play currently selected song
//        guard let item = self.selectedMediaItem else {return}
//        if let url = item.assetURL{
//            let playerItem = AVPlayerItem(url: url)
//            self.progressLbl.text = "00:00"
//            self.totalDurationLbl.text = Globals.secondsMinutesHours(withDuration: item.playbackDuration)
//            if self.avplayer == nil{
//                self.avplayer = AVPlayer(playerItem: playerItem)
//            }else{
//                self.avplayer.replaceCurrentItem(with: playerItem)
//                self.avplayer.seek(to: kCMTimeZero)
//            }
//            self.avplayer.play()
//            self.isPlaying = true
//            self.startVideoTimer()
//        }else{
//            if self.avplayer != nil{
//                self.isPlaying = false
//                self.avplayer.pause()
//                self.endVideoTimer()
//            }
//        }
//    }
//
//    fileprivate func startVideoTimer() {
//        //start player timer to update the palying progress
//        self.endVideoTimer()
//        self.updateVideoPlayProgress()
//        self.videoProgressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(SongsVC.updateVideoPlayProgress), userInfo: nil, repeats: true)
//    }
//
//    fileprivate func endVideoTimer() {
//        //stop player timer
//        self.videoProgressTimer?.invalidate()
//        self.videoProgressTimer = nil
//    }
//
//    @objc fileprivate func updateVideoPlayProgress() {
//        //update the progress view
//        if let player = self.avplayer, let label = self.progressLbl, let prgView = self.progressView {
//            let progress = self.avplayer.currentTime().seconds / CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(seconds: 0.1, preferredTimescale: 600))
//            if progress > 0.0 {
//                label.text = Globals.secondsMinutesHours(withDuration: CMTimeGetSeconds(player.currentTime()))
//                prgView.progress = Float(progress)
//            }
//        }
//    }
//}

