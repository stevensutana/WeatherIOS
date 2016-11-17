//
//  ModuleReverseGeocoding.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import Foundation
import CoreLocation

public class ModuleReverseGeocoding : NSObject
{
    public class func geoCode(location : CLLocation!, completion:(locationName:NSString) -> Void)
    {
        let geocoder : CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location,completionHandler:
            {(data, error) -> Void in
                guard let placeMarks = data as [CLPlacemark]! else
                {
                    return
                }
                
                let loc: CLPlacemark = placeMarks[0]
                
                // City
                if let city = loc.addressDictionary!["City"] as? NSString
                {
                    completion(locationName: city)
                }
        })
    }
}