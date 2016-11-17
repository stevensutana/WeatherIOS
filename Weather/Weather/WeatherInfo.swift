//
//  Weather.swift
//  Weather
//
//  Created by Steven Sutana on 11/15/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import Foundation
import RealmSwift
class WeatherInfo : Object{
    dynamic var dt:NSDate!
    dynamic var local_date:String!
    
    dynamic var temp:Int=0
    dynamic var temp_min:Int=0
    dynamic var temp_max:Int=0
    
    
    dynamic var tempMetric:Int=0
    dynamic var temp_minMetric:Int=0
    dynamic var temp_maxMetric:Int=0
    
    dynamic var humidity:Int=0
    
    dynamic var weather_id:String!
    dynamic var weather_main:String!
    dynamic var weather_desc:String!
    dynamic var weather_icon:String!
    
    dynamic var wind_speed:String!
    dynamic var wind_speedMetric:String!
    
    dynamic var wind_direction:String!
    
    dynamic var pressure:String!
    

    
}