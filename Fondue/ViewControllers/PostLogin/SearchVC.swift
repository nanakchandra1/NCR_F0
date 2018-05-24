//
//  SearchVC.swift
//  Fondue
//
//  Created by Nanak on 22/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class SearchVC: BaseVc {
    
    var searchedTracks = [TracksModel]()
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var underDevLbl: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialSetup()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    

    func initialSetup(){
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.searchBar.setPlaceHolder(with: "Search Tracks", with: UIColor.white)
        self.searchBar.font = AppFonts.Seravek_Regular.withSize(17)
        self.navigationTitleLbl.font = AppFonts.Seravek.withSize(18)
        self.view.backgroundColor = AppColors.lightBlueColor
        self.navigationTitleLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        self.underDevLbl.font = AppFonts.Seravek.withSize(18)

        
    }
}


//MARK:- UITabelview delegate and datasource Method
//MARK:- ==================


extension SearchVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedTracks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTrackCell", for: indexPath) as! SearchTrackCell
        return cell
    }
}



//MARK:- UITabelview cell classess
//MARK:- ==================


class SearchTrackCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
