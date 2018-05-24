//
//  FileManagerExtension.swift
//  WashApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import UIKit

extension FileManager{
    
    ///Prints Core Data URL
    @nonobjc class var printCoreDataURL:Void{
        print(self.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    ///Clears all files of 'Document' directory
    @nonobjc class var clearDocumentDirectory:Void{
        
        let documentsUrl =  self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents : [URL] = try self.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: self.DirectoryEnumerationOptions())
            for videoUrl in directoryContents {
                
                if URL(fileURLWithPath:videoUrl.path).pathExtension.isAnyUrl {
                    removeFile(atPath: videoUrl.path)
                }
            }
        }
        catch {
        }
    }
    
    ///Clears all files of 'Cache' directory
    @nonobjc class var clearCacheDirectory:Void{
        
        let documentsUrl =  self.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let directoryContents : [URL] = try self.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: self.DirectoryEnumerationOptions())
            for videoUrl in directoryContents {
                
                if URL(fileURLWithPath:videoUrl.path).pathExtension.isAnyUrl {
                    removeFile(atPath: videoUrl.path)
                }
            }
        } catch  {
        }
    }
    
    ///Clears all files of 'Temp' directory
    @nonobjc class var clearTempDirectory:Void{
        do {
            let tempDirectory = try self.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
            for file in tempDirectory {
                try self.default.removeItem(atPath: "\(NSTemporaryDirectory())\(file)")
            }
        }
        catch{
        }
    }
    
    ///Removes a file at a given path
    class func removeFile(atPath filePath: String) {
        let fileManager = self.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            }
            catch{
            }
        }
    }
    
    ///Removes all files at a given directroy path
    class func removeFiles(atDirectroyPath directroyPath: String){
        do{
            let array = try self.default.contentsOfDirectory(atPath: directroyPath)
            for file in array{
                removeFile(atPath: "\(directroyPath)/\(file)")
            }
        }
        catch {
        }
    }
}
