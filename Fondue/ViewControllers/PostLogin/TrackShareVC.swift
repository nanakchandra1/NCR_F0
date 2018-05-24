//
//  TrackShareVC.swift
//  Fondue
//
//  Created by Nanak on 18/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class TrackShareVC: BaseVc {
    
    
    //MARK:- Properties
    //MARK:- ==========================

    var listNameArray : [String] = [StringConstants.Message , StringConstants.Snapchat , StringConstants.Messenger , StringConstants.Facebook , StringConstants.WhatsApp , StringConstants.Copy_Link]
    var imageArray : [UIImage] = [#imageLiteral(resourceName: "icPlaylistSharePageMessage"),#imageLiteral(resourceName: "icPlaylistSharePageSnapchat"),#imageLiteral(resourceName: "icPlaylistSharePageMessanger"),#imageLiteral(resourceName: "icPlaylistSharePageFacebook"),#imageLiteral(resourceName: "icPlaylistSharePageWhatsapp"),#imageLiteral(resourceName: "icPlaylistSharePageLink")]
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    
    @IBOutlet weak var shareTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    
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
    
    @IBAction func crossBtnTApp(_ sender: UIButton) {
        
        sharedAppDelegate.parentNavigationController.popViewController(animated: true)
    }

    
}

//MARK:- Private Functions
//MARK:- ==========================

extension TrackShareVC{
    
    private func initialSetUp(){
        
        self.shareTableView.delegate = self
        self.shareTableView.dataSource = self
        self.shareTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationTitleLbl.font = AppFonts.Seravek_Medium.withSize(17)

    }
}

//MARK:- UITableview delegate and datasource methods
//MARK:- ==========================

extension TrackShareVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1

        }else{
            return 6

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 180
        }else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTrackHeaderCell", for: indexPath) as! ShareTrackHeaderCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TracklShareCell", for: indexPath) as! TracklShareCell
            cell.populateData(with: self.imageArray[indexPath.row], title: self.listNameArray[indexPath.row])
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else{return}
        
        
    }
}

//MARK:- Cell Classess
//MARK:- ==========================

class ShareTrackHeaderCell: UITableViewCell {
    
    @IBOutlet weak var blurredImg: UIImageView!
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var playListNameLbl: UILabel!
    @IBOutlet weak var trackNameLbl: UILabel!
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playListNameLbl.font = AppFonts.Seravek_Bold.withSize(22)
        self.trackNameLbl.font = AppFonts.Seravek_Regular.withSize(14)
        self.addBlureEffect()
        
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func addBlureEffect(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.blurredImg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurredImg.addSubview(blurEffectView)

    }
    
    
}

class TracklShareCell: UITableViewCell {
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    @IBOutlet weak var shareSourceImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLbl.font = AppFonts.Seravek_Regular.withSize(16)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func populateData( with image : UIImage , title : String){
        
        self.titleLbl.text = title.localized
        self.shareSourceImage.image = image
    }
}
