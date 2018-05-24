//
//  UITextFieldExtension.swift
//  WoshApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import UIKit

extension UITextField{
    
    ///Sets and gets if the textfield has secure text entry
    var isSecureText:Bool{
        get{
            return self.isSecureTextEntry
        }
        set{
            let font = self.font
            self.isSecureTextEntry = newValue
            if let text = self.text{
                self.text = ""
                self.text = text
            }
            self.font = nil
            self.font = font
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPlaceHolder(with text: String, with color: UIColor){
        
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: color])
        
    }

}
