//
//  ModuleLocation.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import Foundation
import CoreLocation


protocol ModuleLocationDelegate {
    func currentUserLocationIs(locationName: String, coordinates:String)
    func userLocationNotAllowed(locationName: String, coordinates:String)
    func currentUserLocationNotRecognized()
}


class ModuleLocation : NSObject,
    CLLocationManagerDelegate
{
    var delegate : ModuleLocationDelegate?
    
    private var locationManager: CLLocationManager!
    
    var userLocationAlreadyUpdated : Bool = false
    
    override init()
    {
        super.init()
        
    }
    
    func checkLocationNow()  {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if case .AuthorizedWhenInUse = status{
            
            
            manager.startUpdatingLocation()
        }else{
            delegate?.userLocationNotAllowed(defaultStartLocationName, coordinates: defaultCoordinates)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(!userLocationAlreadyUpdated){
            
            manager.stopUpdatingLocation()
            
            let locValue:CLLocationCoordinate2D = self.locationManager.location!.coordinate
            
            userLocationAlreadyUpdated = true
            ModuleReverseGeocoding.geoCode(locationManager.location, completion:{(locationName) -> Void in   //get location name by location coordinates
                self.delegate?.currentUserLocationIs(locationName as String, coordinates:"\(locValue.latitude),\(locValue.longitude)")
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        delegate?.currentUserLocationNotRecognized()
    }
    
}
