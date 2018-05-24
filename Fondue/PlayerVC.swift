//
//  PlayerVC.swift
//  SpotifyDemo
//
//  Created by Nanak on 22/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerVC: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songImg: UIImageView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var playPausebtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var minTimeLbl: UILabel!
    @IBOutlet weak var maxTimeLbl: UILabel!
    
    var trackInfo: TracksModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpViews()
//        size = self.view.frame.size
//        scene = AnimationScene(size: size)
//        let skView = SKView()
//        skView.frame =  self.view.frame
//        self.view.addSubview(skView)
//        skView.presentScene(scene)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViews(){
        
        self.songName.text = self.trackInfo.title
        self.songImg.imageFromURl(self.trackInfo.image, placeHolderImage: #imageLiteral(resourceName: "icMainPageBg"), loader: false) { (success) in
            
        }
        self.slider.minimumValue = 0
        self.slider.value = 0

        self.minTimeLbl.text = "00.00"
        self.maxTimeLbl.text = "00.00"

            //self.loginBtn.isHidden = true
            SpotifyManager.shared.player = SPTAudioStreamingController.sharedInstance()
            SpotifyManager.shared.player?.playbackDelegate = self
            SpotifyManager.shared.player?.delegate = self
            try! SpotifyManager.shared.player?.start(withClientId: SpotifyManager.shared.sharedAuth.clientID!)
            SpotifyManager.shared.player?.login(withAccessToken: SpotifyManager.shared.session.accessToken!)
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        
    }
    
    func audioStreamingDidSkip(toNextTrack audioStreaming: SPTAudioStreamingController!) {
        
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        self.play()
    }
    
    func audioStreamingDidBecomeActivePlaybackDevice(_ audioStreaming: SPTAudioStreamingController!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        self.slider.value = Float(position)
        self.setDurationLbl(with: position)

    }
    
    
    func setDurationLbl(with duration : TimeInterval){
        
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        let minutes = Int(duration / 60)
        self.minTimeLbl.text = "\(minutes)" + ":" + "\(seconds)"

    }
    
    @objc func play() {
        
//        print(songInfo.uri)
        SpotifyManager.shared.player?.playSpotifyURI(self.trackInfo.uri, startingWith: 0, startingWithPosition: 0, callback: { (err) in
            
            print(self.trackInfo.duration)
            let duration = Double(Int(self.trackInfo.duration)).roundTo(places: 2)
            let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
            let minutes = Int(duration / 60)
            self.slider.maximumValue = Float(self.trackInfo.duration)
            self.maxTimeLbl.text = "\(minutes)" + ":" + "\(seconds)"
            
        })
    }

    @IBAction func backBtnTapp(_ sender: UIButton) {
        
        
        SpotifyManager.shared.player?.setIsPlaying(false, callback: nil)
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
    }
    
    @IBAction func previousBtnTapp(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func nextBtnTapp(_ sender: UIButton) {
        
    }

    
    @IBAction func playpauseBtnTapp(_ sender: UIButton) {
        
        if SpotifyManager.shared.player!.playbackState.isPlaying{
            
            SpotifyManager.shared.player?.setIsPlaying(false, callback: nil)
        }else{
            
            
            SpotifyManager.shared.player?.setIsPlaying(true, callback: nil)
        }
        
//        if SpotifyManager.session.isValid(){
//            print("Valid Session")
//            self.play()
//        }
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct Person: Codable {
    let first: String
    let last: String
    let age: Int
    
    enum CodingKeys: String, CodingKey {
        case first
        case last
        case age = "person_age"
    }
}
