//  Weather.swift
//  Weather
//
//  Created by Steven Sutana on 11/15/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//
import RealmSwift

class Weather: Object {
    // Dynamic attribute mean that your property/method can be access by Objective-C code or class. Normally it happen when you sub-classing a Swift class of Objective-C base class. //
    dynamic var weatherId=""
    dynamic var weatherCity=""
    dynamic var weatherCoor=""
    dynamic var weatherAddress=""
    dynamic var weatherTemp=0
    dynamic var weatherTime=""
    dynamic var weatherStatus=0
    
    
    var dayWeatherColl = List<WeatherInfo>()
    var hourWeatherColl = List<WeatherInfo>()
    
    override static func primaryKey() -> String? {
        return "weatherId"
    }
}
