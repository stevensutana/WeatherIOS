//
//  WeatherTimeCollectionViewCell.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherTimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    func SetUpCell(index:Int,Weather:WeatherInfo){
        
        if(index != 0){
            timeLabel.text = Weather.local_date.convertDateFormater()
            humidityLabel.hidden = false
            humidityLabel.text = "\(Weather.humidity) %"
        }else{//current weather 
            timeLabel.text = "Now"
            humidityLabel.hidden = true
            
        }
        
        let url = NSURL(string: Weather.weather_icon)
        iconImage.kf_setImageWithURL(url)
        
        let temp = unitName == "Imperial" ? Weather.temp : Weather.tempMetric
        degreeLabel.text = "\(temp) °"
        
    }
    
}
