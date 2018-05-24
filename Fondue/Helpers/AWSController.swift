
//  AWSController.swift
//  Papas360
//
//  Created by Mohammad Umar Khan on 26/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
import Foundation
import AWSCore
import AWSS3
import AVFoundation
import UIKit

//MARK: Important credentials for AWS(S3)
let S3_BASE_URL = "https://s3.us-east-1.amazonaws.com/"
let BUCKET_NAME = "appinventiv-generic"
let BUCKET_DIRECTORY    = "iOS"

class AWSController {
    
    //MARK: CANCEL REQUEST
    //MARK: =================
    static func cancelAllRequest() {
        AWSS3TransferManager.default().cancelAll()
    }
    
    //MARK: Setting S3 server with the credentials...
    //MARK: =========================================
    static func setupAmazonS3(withPoolID poolID: String) {
        
        let credentialsProvider = AWSCognitoCredentialsProvider( regionType: .USEast1,
                                                                 identityPoolId: poolID)
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    
//    static func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler : @escaping (_ session : AVAssetExportSession) -> Void){
//
//        do {
//            try FileManager.default.removeItem(at: outputURL as URL)
//        }
//        catch {
//
//        }
//        let asset = AVURLAsset(url: inputURL as URL, options: nil)
//        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
//
//        exportSession?.outputURL = outputURL as URL
//
//        exportSession?.outputFileType = AVFileTypeMPEG4
//        exportSession?.exportAsynchronously(completionHandler: {
//
//            handler(exportSession!)
//        })
//    }
    
//    static func uploadTOS3Video(url: URL,
//                                uploadFolderName: String = "",
//                                success : @escaping (Bool, String) -> Void,
//                                progress : @escaping (CGFloat) -> Void,
//                                failure : @escaping (Error) -> Void) {
//
//        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
//        let path = NSTemporaryDirectory().stringByAppendingPathComponent(path: name)
//
//        let dispatchgroup = DispatchGroup()
//
//        dispatchgroup.enter()
//
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let outputurl = documentsURL.appendingPathComponent(name)
//        var ur = outputurl
//        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in
//
//            ur = session.outputURL!
//            dispatchgroup.leave()
//
//        }
//        dispatchgroup.wait()
//
//        let data = NSData(contentsOf: ur as URL)
//
//        do {
//
//            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
//
//        } catch {
//
//            print(error)
//        }
//
//        DispatchQueue.main.async {
//
//            let nurl = NSURL(fileURLWithPath: path)
//
//            guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
//
//                let err = NSError(domain: "There is a problem while making the uploading request.", code : 02, userInfo : nil)
//                failure(err)
//                return
//            }
//
//            uploadRequest.bucket = "\(BUCKET_NAME)/\(BUCKET_DIRECTORY)\(uploadFolderName.isEmpty ? "" : "/\(uploadFolderName)")"
//            uploadRequest.acl    = AWSS3ObjectCannedACL.publicRead
//            uploadRequest.key    = name
//            uploadRequest.body   = nurl as URL!
//            uploadRequest.body  = URL(fileURLWithPath: path)
//
//
//            uploadRequest.uploadProgress = {(
//                bytesSent : Int64,
//                totalBytesSent : Int64,
//                _ totalBytesExpectedToSend : Int64) -> Void in
//
//                progress((CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)))
//                //            print((CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)))
//            }
//
//            AWSS3TransferManager.default().upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Void in
//
//                //MARK: That will remove image from temporary storage (NSTemporaryDirectory())...
//                try? FileManager.default.removeItem(atPath : path)
//                if let err = task.error {
//
//                    failure(err)
//                } else {
//
//                    let url = "https://s3.amazonaws.com/\(BUCKET_NAME)/\(BUCKET_DIRECTORY)\(uploadFolderName.isEmpty ? "" : "/\(uploadFolderName)")/\(name)"
//
//                    success(true, url)
//                }
//            }
//        }
//    }
}

extension UIImage {
    
    //MARK: Uploading image function with S3 server...
    //MARK: ==========================================
    func uploadImageToS3(uploadFolderName: String = "",
                         compressionRatio : CGFloat = 0.5,
                         success : @escaping (Bool, String) -> Void,
                         progress : @escaping (CGFloat) -> Void,
                         failure : @escaping (Error) -> Void) {
        
        let name = "\(Int(Date().timeIntervalSince1970)).png"
        let path = NSTemporaryDirectory().stringByAppendingPathComponent(path: name)
        
        //MARK: Compressing image before making upload request...
        guard let data = UIImageJPEGRepresentation(self, compressionRatio) else {
            let err = NSError(domain: "Error while compressing the image.", code : 01, userInfo : nil)
            failure(err)
            return
        }
        
        //MARK: Making upload request after image compression is done...
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
            
            let err = NSError(domain: "There is a problem while making the uploading request.", code : 02, userInfo : nil)
            failure(err)
            return
        }
        uploadRequest.bucket = "\(BUCKET_NAME)/\(BUCKET_DIRECTORY)\(uploadFolderName.isEmpty ? "" : "/\(uploadFolderName)")"
        uploadRequest.acl    = AWSS3ObjectCannedACL.publicRead
        uploadRequest.key    = name
        
        try? data.write(to: URL(fileURLWithPath : path), options : .atomic)
        uploadRequest.body  = URL(fileURLWithPath: path)
        
        uploadRequest.uploadProgress = {(
            bytesSent : Int64,
            totalBytesSent : Int64,
            _ totalBytesExpectedToSend : Int64) -> Void in
            
            progress((CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)))
            //            print((CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)))
        }
        
        AWSS3TransferManager.default().upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Void in
            
            //MARK: That will remove image from temporary storage (NSTemporaryDirectory())...
            try? FileManager.default.removeItem(atPath : path)
            if let err = task.error {
                
                failure(err)
            } else {
                
                let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)\(uploadFolderName.isEmpty ? "" : "/\(uploadFolderName)")/\(name)"
                //                printDebug(imageURL)
                success(true, imageURL)
            }
        }
    }
}


extension UIDocument {
    
    func uploadDocumentTOS3(uploadFolderName: String = "",
                            success : @escaping (Bool, String) -> Void,
                            progress : @escaping (CGFloat) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        guard let fileExtension = self.fileURL.lastPathComponent.components(separatedBy: ".").last else {
            return
        }
        
        let name = "\(Int(Date().timeIntervalSince1970)).\(fileExtension)"
        let path = NSTemporaryDirectory().stringByAppendingPathComponent(path: name)
        
        //        let data = AWSManager.compressImageWithSize(0.3, currentImage: image)
        do {
            let data = try Data(contentsOf: self.fileURL)
            
            try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
            
            let url = URL(fileURLWithPath: path)
            
            guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
                
                let err = NSError(domain: "There is a problem while making the uploading request.", code : 02, userInfo : nil)
                failure(err)
                return
            }
            
            uploadRequest.bucket = "\(BUCKET_NAME)/\(BUCKET_DIRECTORY)\(uploadFolderName.isEmpty ? "" : "/\(uploadFolderName)")"
            uploadRequest.acl           = AWSS3ObjectCannedACL.publicRead
            uploadRequest.key           = name
            uploadRequest.contentType   = "file/pdf"
            uploadRequest.body          = url
            
            uploadRequest.uploadProgress = {(
                bytesSent : Int64,
                totalBytesSent : Int64,
                _ totalBytesExpectedToSend : Int64) -> Void in
                
                progress((CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)))
                //            print((CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)))
            }
            
            AWSS3TransferManager.default().upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Void in
                
                //MARK: That will remove image from temporary storage (NSTemporaryDirectory())...
                try? FileManager.default.removeItem(atPath : path)
                if let err = task.error {
                    
                    failure(err)
                } else {
                    
                    let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)\(uploadFolderName.isEmpty ? "" : "/\(uploadFolderName)")/\(name)"
                    //                printDebug(imageURL)
                    success(true, imageURL)
                }
            }
            
        }catch {
            print("error")
            return
        }
    }
}

