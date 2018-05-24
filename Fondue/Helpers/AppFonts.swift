//
//  AppFonts.swift
//  DannApp
//
//  Created by Aakash Srivastav on 20/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit


enum AppFonts : String {
    
    case Seravek_Bold = "Seravek-Bold"
    case Seravek_BoldItalic = "Seravek-BoldItalic"
    case Seravek_ExtraLight = "Seravek-ExtraLight"
    case Seravek_ExtraLightItalic = "Seravek-ExtraLightItalic"
    
    case Seravek_Italic = "Seravek-Italic"
    case Seravek_Light = "Seravek-Light"
    case Seravek_Regular = "Seravek-Regular"
    case Seravek_LightItalic = "Seravek-LightItalic"
    case Seravek_Medium = "Seravek-Medium"
    case Seravek_MediumItalic = "Seravek-MediumItalic"
    case Seravek = "Seravek"
    
    
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
