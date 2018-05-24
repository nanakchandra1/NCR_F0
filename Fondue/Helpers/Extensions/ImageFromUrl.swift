//
//  ImageFromUrl.swift
//  Onboarding
//
//  Created by Appinventiv on 29/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension NSCache {
    @objc class var sharedInstance: NSCache<NSString, AnyObject> {
        let cache = NSCache<NSString, AnyObject>()
        return cache
    }
}

let imageCache = NSCache<AnyObject, AnyObject>.sharedInstance

extension UIImageView{
    
    func imageFromURl(_ urlString: String,placeHolderImage : UIImage? = nil,loader : Bool = false,completion : ((Bool)->Void)? = nil){
        
        let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        if loader {
            self.layoutIfNeeded()
            activityIndicator.frame = CGRect(x: self.bounds.width/2, y: self.bounds.height/2, width: 30, height: 30)
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        func callCompletion(_ image : UIImage?,_ success : Bool){
            self.image = image
            if loader{
                activityIndicator.removeFromSuperview()
            }
            completion?(success)
        }
        
        
        if let url = NSURL(string: urlString) {
            
            if let cachedImage = imageCache.object(forKey: urlString as NSString){
                if let image = cachedImage as? UIImage {
                    callCompletion(image, true)
                }else{
                    callCompletion(placeHolderImage, false)
                }
            }else{
                DispatchQueue.global().async {
                    if let data = NSData(contentsOf: url as URL) {
                        let img = UIImage(data: data as Data)
                        
                        DispatchQueue.main.async {
                            
                            if let image = img {
                                imageCache.setObject(image, forKey: urlString as NSString)
                                callCompletion(image, true)
                            }else{
                                callCompletion(placeHolderImage, false)
                            }
                        }
                    }else{
                        callCompletion(placeHolderImage, false)
                    }
                }
            }
        }else{
            callCompletion(placeHolderImage, false)
        }
    }
    
    func thumnailImage(fromUrl urlString : String) {
        
        guard let url = URL(string: urlString ) else{
            return
        }
        
        let ast = AVAsset(url: url)
        
        let assetImgGenerate = AVAssetImageGenerator(asset: ast)
        
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time : CMTime = CMTimeMakeWithSeconds(2, Int32(NSEC_PER_SEC))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            if let cgImage = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) {
                
                let thumbImage = UIImage(cgImage: cgImage)
                
                self.image = thumbImage
            }
        })
    }
}
