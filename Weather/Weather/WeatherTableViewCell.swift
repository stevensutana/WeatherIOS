//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit
import Gifu

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var gifImage: AnimatableImageView!
    @IBOutlet weak var cityDirection: UILabel!
    @IBOutlet weak var timeNow: UILabel!
    @IBOutlet weak var mainTemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(wi:Weather){
        cityDirection.text = wi.weatherCity
        let temp = unitName == "Imperial" ? wi.weatherTemp : wi.weatherTemp.convertToCelsius()
        mainTemp.text = "\(temp) °"
        timeNow.text = wi.weatherTime
        let status_weather = Int(wi.weatherStatus)
        let mod_status = status_weather / 100 //getting group of weather
        var gifName = String()
        switch mod_status {
        case 2:
            gifName += "Storm"
            break
        case 3:
            gifName += "Rain"
            break
        case 5:
            gifName += "Rain"
            break
        case 6:
            gifName += "Snow"
            break
        case 7:
            gifName += "Fog"
            break
        case 8:
            gifName += "Cloud"
            break
        case 9:
            gifName += "Extreme"
            break
        default:
            gifName = "Rain"
            break
        }
        
        gifName = "dummy\(gifName).gif"
        gifImage.contentMode = .ScaleAspectFill
        self.gifImage.animateWithImage(named: gifName)
        self.gifImage.startAnimatingGIF()
    }
}
