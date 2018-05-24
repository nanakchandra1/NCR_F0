//
//  BrowseVC.swift
//  Onboarding
//
//  Created by macOS on 13/02/18.
//  Copyright © 2018 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class BrowseVC: BaseVc {
    
    //MARK:- Properties
    //==================
    var browseModelArray =  [BrowseModel]()
    var color = [AppColors.parrotGreenColor, AppColors.blueColor, AppColors.orangeColor, AppColors.pinkColor, AppColors.ylwColor]
    private var data: [Any] = []
    private var deezerObjectList: DZRObjectList? {
        didSet {
            getData()
        }
    }
    var object: DeezerObject?
    var selectedDSP : SelectedDSPs = .Spotify
    var songsList = [SPTPlaylistTrack]()
    
    
    //MARK:- IBOutlet
    //===============
    @IBOutlet weak var naigationView: UIView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var browseTableView: UITableView!
    @IBOutlet weak var underDevLbl: UILabel!
    
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        
    }
    
    private func initialSetup() {
        
        self.browseTableView.delegate = self
        self.browseTableView.dataSource = self
        self.browseTableView.estimatedRowHeight = 50
        self.navTitleLabel.font = AppFonts.Seravek.withSize(18)
        self.view.backgroundColor = AppColors.lightBlueColor
        self.navTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        self.underDevLbl.font = AppFonts.Seravek.withSize(18)

        if self.selectedDSP == .Deezer{
            
            self.getObjectList()
        }
        
    }
    
    
    func getObjectList() {
        
        guard let type = self.object?.type else {
            return
        }
        
        type.getObjectList(object: object?.object, callback: { [weak self] (deezerObjectList, error) in
            guard let deezerObjectList = deezerObjectList, let strongSelf = self else {
                print(error.debugDescription )
                return
            }
            strongSelf.deezerObjectList = deezerObjectList
        })
    }
    
    func getData() {
        
        guard let objectList = self.deezerObjectList else {
            return
        }
        
        DeezerManager.sharedInstance.getData(fromObjectList: objectList) {[weak self] (data, error) in
            guard let data = data, let strongSelf = self else {
                if let error = error {
                    showToastWithMessage(error.localizedDescription)
                }
                return
            }
            
            strongSelf.data = data
            strongSelf.browseTableView.reloadData()
        }
    }
    
    
    private func setup(track: DZRTrack) {
       // clearUI()
        
        DeezerManager.sharedInstance.getData(track: track) {[weak self] (data, error) in
            guard let data = data, let strongSelf = self else {
                if let error = error {
                    showToastWithMessage(error.localizedDescription)
                }
                return
            }
            if let artist = data[DZRPlayableObjectInfoCreator] as? String {
                print_debug("++++++++++++++ Artist Name +++++++++++++++++\n \(artist) \n")
            }
            
            if let album = data[DZRPlayableObjectInfoSource] as? String {
                print_debug("++++++++++++++ album Name +++++++++++++++++\n \(album) \n")
            }
            
            if let title = data[DZRPlayableObjectInfoName] as? String {
                print_debug("++++++++++++++ title Name +++++++++++++++++\n \(title) \n")
            }
        }
        
        DeezerManager.sharedInstance.getIllustration(track: track) {[weak self] (image, error) in
            guard let image = image, let strongSelf = self else {
                if let error = error {
                    showToastWithMessage(error.localizedDescription)
                }
                return
            }
            
            print_debug("++++++++++++++ image Name +++++++++++++++++\n \(image) \n")
        }
    }
    
    //MARK:- IBActions
    //================
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
    }
    
}

extension BrowseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.selectedDSP {
            
        case .Spotify:
            
            return self.songsList.count
            
        case .Deezer:
            
            return data.count
            
        case .AppleMusic:
            
            return 0
            
        case .Tidel:
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseCell") as? BrowseCell else { fatalError("invalid cell") }
        switch self.selectedDSP {
            
        case .Spotify:
            
            cell.songCategoryLabel.text = self.songsList[indexPath.row].name
            
        case .Deezer:
            
            guard let deezerObject = data[indexPath.row] as? DZRObject else {
                return cell
            }
            guard let dzrTrack = deezerObject as? DZRTrack else{break }
            print_debug(dzrTrack)
            self.setup(track: dzrTrack)
            cell.songCategoryLabel.text = deezerObject.description
            
        case .AppleMusic:
            
            print_debug("")
            
        case .Tidel:
            
            print_debug("")
            
        }
        return cell
    }
    
}

//MARK:- PrototypeCell
//======================
class BrowseCell: UITableViewCell {
    
    //MARK:- Properties
    //==================
    
    //MARK:- IBOutlet
    //===============
    @IBOutlet weak var songCategoryLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}



