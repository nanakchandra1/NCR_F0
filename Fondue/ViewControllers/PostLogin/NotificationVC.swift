//
//  NotificationVC.swift
//  Fondue
//
//  Created by Nanak on 20/04/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    
    var notificationsData = JSONDictionaryArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

//MARK:- Private Methods
//MARK:- ==========================

extension NotificationVC{
    
    private func initialSetup(){
        
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.estimatedRowHeight = 100
        self.notificationTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.getNotificatinons()
        
    }
    
    
    private func getNotificatinons(){
        
        var params = JSONDictionary()
        params["token"] = CurrentUser.accessToken ?? ""
        
        WebServices.getNotificationsAPI(parameters: params, webServiceSuccess: { (success, msg, notifications) in
            
            
        }) { (error) -> (Void) in
            
        }
    }
}


//MARK:- UITableview delegate and datasource methods
//MARK:- ==========================

extension NotificationVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestNotificationCell", for: indexPath) as! RequestNotificationCell
        return cell

    }
    
}

//MARK:- Cell Classess
//MARK:- ==========================

class RequestNotificationCell: UITableViewCell {
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    //MARK:- IBOutlets
    //MARK:- ==========================
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.acceptBtn.backgroundColor = AppColors.btnTextGreenLightColor
        self.acceptBtn.titleLabel?.font = AppFonts.Seravek_Medium.withSize(17)
        self.rejectBtn.backgroundColor = AppColors.btnTextGreenLightColor
        self.rejectBtn.titleLabel?.font = AppFonts.Seravek_Medium.withSize(17)

    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    
}


