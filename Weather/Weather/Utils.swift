//
//  Utils.swift
//  Weather
//
//  Created by Steven Sutana on 11/15/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit

extension NSDate {
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        
        //Return Result
        return isLess
    }
    
    
    func dayOfTheWeek() -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(self)
    }
    
    
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: date, options: []).day
    }
    
    
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: date, options: []).hour
    }
}

extension Float {
    var cleanValue: String {
        return String(format: "%.0f", self)
    }
}

extension UILabel{
    func animateWithText(text:String){
        UIView.transitionWithView(self,
                                  duration: 0.7,
                                  options: [.TransitionCrossDissolve],
                                  animations: {
                                    
                                    self.text = text
                                    
            }, completion: nil)
    }
}


extension String{
    
    func convertDateFormater() -> String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy, hh:mm:ss a"//this your string date format
        //    dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(self)
        
        
        dateFormatter.dateFormat = "h a"///this is you want to convert format
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        
        return timeStamp
    }
    
    func convertLocalHour() -> String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy, hh:mm:ss a"//this your string date format
        let date = dateFormatter.dateFromString(self)
        
        
        dateFormatter.dateFormat = "hh:mm a"///this is you want to convert format
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        
        return timeStamp
    }
    

}

extension Int{
    
    func convertToCelsius() -> Int {
        return Int(5.0 / 9.0 * (Double(self) - 32.0))
    }
    
    
    func convertToMPH() -> Int {
        return Int(Double(self) / 0.44704)
    }
}
