//
//  CLLocationExtension.swift
//  WashApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import CoreLocation

///API key provided by Google. Replace this key with yours
let Google_API_Key = "AIzaSyAvdSIscCxaL0LuJvDjfuNm8EEeZbNNgxo"

///Defines all available transportation modes within enum 'TransportationMode'
enum TransportationMode:String {
    
    case bicycling = "bicycling"
    case transit = "transit"
    case driving = "driving"
    case walking = "walking"
}

extension CLLocation{
    
    ///Calculates estimated time of a location from other location based on the transportation mode selected.
    func estimatedTime(fromLocation:CLLocation, transportationMode:TransportationMode = .driving,completion:@escaping ((_ travelTime:String?)->Void)){
        
        DispatchQueue.backgroundQueueAsync {
            
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.coordinate.latitude),\(self.coordinate.longitude)&destination=\(fromLocation.coordinate.latitude),\(fromLocation.coordinate.longitude)&sensor=false&mode=\(transportationMode.rawValue)&key=\(Google_API_Key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            if let url = URL(string:urlString) {
                
                do{
                    let responseData = try Data(contentsOf:url)
                    if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any],let routes = jsonDict["routes"] as? [[String:Any]],routes.count > 0,let arrLeg = routes[0]["legs"] as? [[String:Any]],arrLeg.count > 0, let duration = arrLeg[0]["duration"] as? [String:Any], let text = duration["text"]{
                        
                        completion("\(text)")
                        return
                    }
                }
                catch{
                    
                }
            }
            completion(nil)
        }
    }
    
    ///Fetchs an Array containing information to draw a path between two locations based on the given transportation mode
    func path(fromLocation:CLLocation, transportationMode:TransportationMode = .driving, completion:@escaping ((_ routes:[[String:Any]]?)->Void)){
        
        DispatchQueue.backgroundQueueAsync {
            
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.coordinate.latitude),\(self.coordinate.longitude)&destination=\(fromLocation.coordinate.latitude),\(fromLocation.coordinate.longitude)&sensor=false&mode=\(transportationMode.rawValue)&key=\(Google_API_Key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string:urlString) {
                
                do{
                    let responseData = try Data(contentsOf:url)
                    if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject],let routes = jsonDict["routes"] as? [[String:Any]],routes.count > 0{
                        
                        completion(routes)
                        return
                    }
                }
                catch{
                    
                }
            }
            completion(nil)
        }
    }
    
    func convertToAddress(_ completionBlock : @escaping ((CountryDetail) -> Void)) {
        
        self.convertToPlaceMark { (placemark : CLPlacemark) -> Void in
            
            print_debug(placemark.addressDictionary)
            let locationAddress = placemark.addressDictionary!
            
            
            let model = CountryDetail(withCountryDetails: locationAddress as [NSObject : AnyObject], location: self)
            completionBlock(model)
        }
    }
    
    
    func convertToPlaceMark(_ completion : @escaping (CLPlacemark) -> Void) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(self,
                                        
                                        completionHandler: { (placemarks, error) -> Void in
                                            
                                            if placemarks != nil {
                                                
                                                let placeArray = placemarks! as [CLPlacemark]
                                                
                                                let placeMark: CLPlacemark! = placeArray[0]
                                                
                                                completion(placeMark)
                                                
                                            }
        })
    }
}
