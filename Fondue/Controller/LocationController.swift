//
//  LocationController.swift
//  Onboarding
//
//  Created by Appinventiv on 22/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import CoreLocation

let SharedLocationManager = LocationController.sharedLocationManager

class LocationController : NSObject, CLLocationManagerDelegate {
    
    static let sharedLocationManager = LocationController()
    
    fileprivate var locationUpdateCompletion : ((CLLocation)->Void)?
    
    let locationManager = CLLocationManager()
    
    var currentLocation : CLLocation!
    
    var locationsEnabled : Bool {
        
        if( CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied) {
                
                return true
                
        } else {
            
            return false
        }
    }
    
    fileprivate override init() {
        
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = CLActivityType.otherNavigation
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 500.0
    }
    
    func fetchCurrentLocation(_ completion : @escaping (CLLocation)->Void){
        
        self.locationUpdateCompletion = completion
        getCurrentLocation()
        
    }
    
    fileprivate func getCurrentLocation() {
        
        if self.locationsEnabled {
            
            self.locationManager.startUpdatingLocation()
            
        } else {
            
            if CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
                
            } else {
                self.locationManager.requestAlwaysAuthorization()
            }
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print_debug(error.localizedDescription)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let _ = self.locationUpdateCompletion {
            
            self.locationUpdateCompletion?(locations.last!)
        }
    }
}
