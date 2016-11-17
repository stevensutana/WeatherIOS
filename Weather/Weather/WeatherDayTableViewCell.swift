//
//  WeatherDayTableViewCell.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit

class WeatherDayTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    func SetUpCell(Weather:WeatherInfo){
        
        dayLabel.text = Weather.dt.dayOfTheWeek()!
        let url = NSURL(string: Weather.weather_icon)
        iconImage.kf_setImageWithURL(url)
        let temp_max = unitName == "Imperial" ? Weather.temp_max : Weather.temp_maxMetric
        let temp_min = unitName == "Imperial" ? Weather.temp_min : Weather.temp_minMetric
        tempMaxLabel.text = "\(temp_max) °"
        tempMinLabel.text = "\(temp_min) °"
        
    }

}
