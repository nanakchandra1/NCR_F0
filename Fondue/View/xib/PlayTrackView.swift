//
//  PlayTrackView.swift
//  Onboarding
//
//  Created by macOS on 14/02/18.
//  Copyright © 2018 Gurdeep Singh. All rights reserved.
//

import UIKit

class PlayTrackView: UIView {

    //MARK:- Properties
    //==================
    
    //MARK:- IBOutlet
    //===============
    @IBOutlet var playTrackBgView: UIView!
    @IBOutlet weak var playTrackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackSingerNameLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    var tracks = [TracksModel]()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.initialSetup()
    }
    
    required init(coader aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func playBtnTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.playBtn.setImage(#imageLiteral(resourceName: "icMainPagePause"), for: .normal)
        }else{
            self.playBtn.setImage(#imageLiteral(resourceName: "icMainPagePlay"), for: .normal)
        }
    }
    
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.tracks(notificatin:)), name: .playSongNotification, object: nil)
        Bundle.main.loadNibNamed("PlayTrackView", owner: self, options: nil)
        addSubview(self.playTrackBgView)
        self.playTrackBgView.frame = self.bounds
        self.playTrackBgView.autoresizingMask   = [.flexibleHeight, .flexibleWidth]
        self.trackNameLabel.textColor           = UIColor.white
        self.trackSingerNameLabel.textColor     = UIColor.white

    }
    
    @objc func tracks(notificatin: Notification){
        guard let tracks = notificatin.userInfo!["tracks"] as? [TracksModel] else{return}
        print(tracks.first!.title)
        self.playBtn.setImage(#imageLiteral(resourceName: "icMainPagePause"), for: .normal)
//        self.searchTracks(tracks: tracks.first!.title)
    }
    
    
//    func searchTracks(tracks: String){
//        let url = "https://api.spotify.com/v1/search"
//        var params = JSONDictionary()
//        params["q"] = tracks
//        params["type"] = "track"
//
//        WebServices.spotifySearchracksAPI(url: url,header: ["Authorization": "Bearer "+(SpotifyManager.session.accessToken!)], webServiceSuccess: { (success, msg, data) in
//
//        }) { (err) -> (Void) in
//            print_debug(err.localizedDescription)
//        }
//    }
    
    //    @objc func play() {
    //
    //        //        print(songInfo.uri)
    ////        print(self.songInfo.sharingURL)
    //        SpotifyManager.player?.playSpotifyURI(self.tracks.first?.uri, startingWith: 0, startingWithPosition: 0, callback: { (err) in
    //
    ////            print(self.songInfo.duration)
    ////            let duration = Double(Int(self.songInfo.duration)).roundTo(places: 2)
    ////            let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
    ////            let minutes = Int(duration / 60)
    ////            self.slider.maximumValue = Float(self.songInfo.duration)
    ////            self.maxTimeLbl.text = "\(minutes)" + ":" + "\(seconds)"
    //
    //        })
    //    }
    
}


//extension PlayTrackView : SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate{
//
//    func audioStreamingDidSkip(toNextTrack audioStreaming: SPTAudioStreamingController!) {
//
//    }
//
//    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
//        self.play()
//    }
//
//    func audioStreamingDidBecomeActivePlaybackDevice(_ audioStreaming: SPTAudioStreamingController!) {
//    }
//
//    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
//    }
//
//    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
//    }
//
//    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
////        self.slider.value = Float(position)
////        self.setDurationLbl(with: position)
//
//    }
//
//}

