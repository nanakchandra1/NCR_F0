//
//  BaseVc.swift
//  Onboarding
//
//  Created by appinventiv on 23/06/17.
//  Copyright © 2017 appinventiv. All rights reserved.
//

import UIKit

class BaseVc: UIViewController, UIGestureRecognizerDelegate {
    
    //Properties
    private var keyboardShowNotification : NSObjectProtocol?
    private var keyboardHideNotification : NSObjectProtocol?
    var target: BaseVc!
    
    var keyBoardAppearClosure : ((_ keyboardHeight : CGFloat) -> ())?
    var keyBoardDisappearClosure : (() -> ())?
    var tapGasture = UITapGestureRecognizer()
    
    var isLoading : Bool = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // self.automaticallyAdjustsScrollViewInsets = false
        // self.initialUILoading()
        //self.automaticallyAdjustsScrollViewInsets = false
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        tapGasture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        //Ending the editing of the view to hide any input view
        self.view.endEditing(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //Notification Observer to decrease the size and scroll the tableView
        self.keyboardShowNotification = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
                                                                               object: nil,
                                                                               queue: OperationQueue.main,
                                                                               using: {[weak self] (notification) in
                                                                                if let strongSelf = self{
                                                                                    strongSelf.view.addGestureRecognizer(strongSelf.tapGasture)
                                                                                }
                                                                                
                                                                                
        })
        
        
        //Notification Observer to increase the size of the tableView
        self.keyboardHideNotification = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
                                                                               object: nil,
                                                                               queue: OperationQueue.main,
                                                                               using: {[weak self] (notification) in
                                                                                if let strongSelf = self{
                                                                                    strongSelf.view.removeGestureRecognizer(strongSelf.tapGasture)
                                                                                }
                                                                                
                                                                                
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Removing Observer on keyboard
        if let keyboardShowNotification = self.keyboardShowNotification {
            NotificationCenter.default.removeObserver(keyboardShowNotification)
        }
        
        if let keyboardHideNotification = self.keyboardHideNotification {
            NotificationCenter.default.removeObserver(keyboardHideNotification)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: Private Functions
extension BaseVc {
    
    
    @objc func dismissKeyboard(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }) { (true) in
            
        }
    }
    //Function to change the image of leftBarButtonItem and add the pop functionality
    func leftBarItemImage(change withImage: UIImage, ofVC target: BaseVc){
        
        self.target = target
        
        var image = withImage
        
        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        target.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pop))
    }
    
    
    //    func leftBarItemImageForSideMenu(change withImage: UIImage, ofVC target: BaseVc){
    //
    //        self.target = target
    //
    //        var image = withImage
    //
    //        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    //
    //        target.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackToSideVC))
    //    }
    //
    //    func rightBarItemImage(change withImage: UIImage, ofVC target: BaseVc){
    //
    //        self.target = target
    //
    //        var image = withImage
    //
    //        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    //
    //        target.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightBarButtonTapped(sender:)))
    //
    //    }
    //
    //    func rightBarButtonTapped(sender : UIButton) {
    //
    //
    //    }
    //
    //    func goBackToSideVC(_ sender : UIBarButtonItem) {
    //        openLeft()
    //    }
    
    
    
}


