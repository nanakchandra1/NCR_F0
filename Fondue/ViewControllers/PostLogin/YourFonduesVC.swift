//
//  YourFonduesVC.swift
//  Fondue
//
//  Created by Nanak on 22/02/18.
//  Copyright © 2018 Nanak. All rights reserved.
//

import UIKit

class YourFonduesVC: BaseVc {

    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var underDevLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationTitleLbl.font = AppFonts.Seravek.withSize(18)
//        self.view.backgroundColor = AppColors.lightBlueColor
        self.navigationTitleLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        self.underDevLbl.font = AppFonts.Seravek.withSize(18)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
