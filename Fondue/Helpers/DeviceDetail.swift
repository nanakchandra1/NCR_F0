//
//  DeviceDetail.swift
//  Onboarding
//
//  Created by Appinventiv on 22/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct DeviceDetail {
        
    static var device_model : String {
        return UIDevice.current.model
    }
    
    static var os_version : String {
        return UIDevice.current.systemVersion
    }
    static var platform : String {
        return UIDevice.current.systemName
    }
    
    static var device_id : String {
        
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static var ipaddress : String? {
        
        return getWiFiAddress()
    }
    
    static var networkType : String? {
        
        return getNetworkType()
    }
        
    static var deviceToken = "DummyDeviceToken"
    
    fileprivate static func getNetworkType() -> String? {
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar"),let foregroundView = (statusBar as AnyObject).value(forKey: "foregroundView") {
            
            let subviews = (foregroundView as AnyObject).subviews
            for subView in subviews! {
                
                if subView.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                    
                    if let value = subView.value(forKey: "dataNetworkType") {
                        
                        switch JSON(value).intValue {
                            
                        case 0:
                            return nil
                            
                        case 1:
                            return "2G"
                            
                        case 2:
                            return "3G"
                            
                        case 3:
                            return "4G"
                            
                        case 4:
                            return "LTE"
                            
                        case 5:
                            return "Wifi"
                            
                        default:
                            return nil
                        }
                    }
                }
            }
        }
        return nil
    }
    
    fileprivate static func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // Check interface name:
                    if let name = String(validatingUTF8: (interface?.ifa_name)!), name == "en0" {
                        
                        // Convert interface address to a human readable string:
                        var addr = interface?.ifa_addr.pointee
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr!, socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }

}
