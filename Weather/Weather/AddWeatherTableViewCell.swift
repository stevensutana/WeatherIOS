//
//  AddWeatherTableViewCell.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit

class AddWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var celciusBtn: UIButton!
    @IBOutlet weak var fahnBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func metricsClick(sender: AnyObject) {
        if(unitName != "Metric"){
            ReloadWeathersDelegate()
            unitName = "Metric"
            fahnBtn.highlighted = true
            celciusBtn.highlighted = false
        }
    }
    
    @IBAction func imperialClick(sender: AnyObject) {
        if(unitName != "Imperial"){
            ReloadWeathersDelegate()
            unitName = "Imperial"
            fahnBtn.highlighted = false
            celciusBtn.highlighted = true
        }
    }


}
