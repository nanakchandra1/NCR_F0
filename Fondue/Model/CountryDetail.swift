//
//  CountryDetail.swift
//  Onboarding
//
//  Created by Appinventiv on 24/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import CoreLocation

struct CountryDetail {
    
    var longitude : Double?
    var latitude : Double?
    var country_code : String?
    var region : String?
    var city : String?
    var postal_code : String?
    
    init(withCountryDetails info : [AnyHashable: Any],location : CLLocation) {
        
        if let postal_code = info["ZIP"] {
            self.postal_code = postal_code as? String
        }
        if let country_code = info["CountryCode"] {
            self.country_code = country_code as? String
        }
        if let region = info["SubLocality"] {
            self.region = region as? String
        }
        if let city = info["City"] {
            self.city = city as? String
        }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
