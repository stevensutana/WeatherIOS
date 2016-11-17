//
//  ApiManager.swift
//  Weather
//
//  Created by Steven Sutana on 11/15/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


func GetWeather(location:String,unit:String,completion: (responseObject: JSON?,statusCode:Int,error: NSError?) -> ()) {
    var statusCode = 0
    Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/forecast?q=\(location),us&appid=\(openWeatherAPIKey)&units=\(unit)",parameters:[:])
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            var json:JSON = ""
            if let value = response.result.value {
                json = JSON(value)
            }
            if let sCode = response.response?.statusCode {
                statusCode = sCode
            }
            
            switch(response.result){
            case .Success:
                debugPrint("SUCCESS get weather ==== statusCode: \(response.response?.statusCode) === JSON:")
                debugPrint(json)
                completion(responseObject: json, statusCode: statusCode, error: nil)
                break
            case .Failure(let error):
                debugPrint("FAILED get weather ==== statusCode: \(response.response?.statusCode) === JSON:\n\(response.result.value)")
                if error.code == -1009 {
                    statusCode = error.code
                    completion(responseObject: json, statusCode: statusCode, error: error)
                } else {
                    completion(responseObject: json, statusCode: statusCode, error: error)
                }
                break
            }
    }
}

func GetWeatherWithCoord(lat:String,lon:String,unit:String,completion: (responseObject: JSON?,statusCode:Int,error: NSError?) -> ()) {
    var statusCode = 0
    Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(openWeatherAPIKey)&units=\(unit)",parameters:[:])
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            var json:JSON = ""
            if let value = response.result.value {
                json = JSON(value)
            }
            if let sCode = response.response?.statusCode {
                statusCode = sCode
            }
            
            switch(response.result){
            case .Success:
                debugPrint("SUCCESS get weather ==== statusCode: \(response.response?.statusCode) === JSON:")
                debugPrint(json)
                completion(responseObject: json, statusCode: statusCode, error: nil)
                break
            case .Failure(let error):
                debugPrint("FAILED get weather ==== statusCode: \(response.response?.statusCode) === JSON:\n\(response.result.value)")
                if error.code == -1009 {
                    statusCode = error.code
                    completion(responseObject: json, statusCode: statusCode, error: error)
                } else {
                    completion(responseObject: json, statusCode: statusCode, error: error)
                }
                break
            }
    }
}


