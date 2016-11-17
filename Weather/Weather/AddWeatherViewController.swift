//
//  AddWeatherViewController.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit
import RealmSwift
import GooglePlaces

class AddWeatherViewController: UIViewController {
    
    let wi=Weather()
    let dateFormatter = NSDateFormatter()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
        dateFormatter.timeZone = NSTimeZone()
        weaherDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - IBAction
    
    @IBAction func addWeather(sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func metricsClick(sender: AnyObject) {
        if(unitName != "Metric"){
            self.tableView.reloadData()
            unitName = "Metric"
        }
    }
    
    @IBAction func imperialClick(sender: AnyObject) {
        if(unitName != "Imperial"){
            self.tableView.reloadData()
            unitName = "Imperial"
        }
    }
    
    @IBAction func sort(sender: AnyObject) {
//        weatherList = weatherList?.sorted("weatherCity")
        sortAndUpdateLocal()
        
//        createUserdata(weatherList)
        self.tableView.reloadData()
    }
    
}

extension AddWeatherViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        wi.weatherId = place.placeID
        wi.weatherCity = place.name
        wi.weatherCoor = String(place.coordinate.latitude)+";"+String(place.coordinate.longitude)
        wi.weatherAddress = place.formattedAddress!
        weaherDelegate?.AddWeather()
        AddViewDelegate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}

extension AddWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row==weatherList!.count) {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddWeatherTableViewCell", forIndexPath: indexPath) as! AddWeatherTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("WeatherTableViewCell", forIndexPath: indexPath) as! WeatherTableViewCell
            cell.setupCell(weatherList![indexPath.row])
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList!.count+1 //addLastRow
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == weatherList!.count {
            let indexPercentage:CGFloat = CGFloat(weatherList!.count)/10
            if(indexPercentage<0.8){
                return tableView.frame.size.height*(1-indexPercentage)
            } else {
                return tableView.frame.size.height*0.2
            }
        } else {
            return tableView.frame.size.height*0.1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.row != weatherList!.count) {
            return .Delete
        } else {
            return .None
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteUserdata(weatherList![indexPath.row])
            DeleteViewDelegate(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != weatherList!.count) {
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            SetViewDelegate(indexPath.row)
//            GetData(indexPath.row)
        
        }
    }
}

extension AddWeatherViewController: WeatherDelegate {
    func AddWeather(){
        currentUserLocationIs(wi.weatherCity, coordinates: wi.weatherCoor)
    }
    
    func ReloadWeathers() {
        self.tableView.reloadData()
    }
}

extension AddWeatherViewController:ModuleLocationDelegate{
    func currentUserLocationIs(locationName: String, coordinates:String){
        
        let coordArr = coordinates.componentsSeparatedByString(";")
        
        let lat: String = coordArr[0]
        let lon: String = coordArr[1]
        //because we use google autocomplete, we use coord for best precisions for request API to openweather
        GetWeatherWithCoord(lat,lon:lon, unit: "Imperial"){(responseObject,statusCode,error) in
            if(error == nil){
                let jsonArr = responseObject!["list"].arrayValue
                var diffDay : Int = 1
                for json in jsonArr{
                    let weather = WeatherInfo()
                    
                    let date = NSDate()
                    let dateTimeFirstTarget = NSDate(timeIntervalSince1970: NSTimeInterval(json["dt"].stringValue)!)
                    let tmpDiffDay = date.daysFrom(dateTimeFirstTarget)
                    
                    let dt = NSTimeInterval(json["dt"].stringValue)!
                    
                    weather.dt = NSDate(timeIntervalSince1970: dt)
                    
                    weather.local_date = self.dateFormatter.stringFromDate(weather.dt)
                    
                    weather.temp = json["main"]["temp"].intValue
                    weather.temp_min = json["main"]["temp_min"].intValue
                    weather.temp_max = json["main"]["temp_max"].intValue
                    
                    
                    weather.tempMetric = weather.temp.convertToCelsius()
                    weather.temp_minMetric = weather.temp_min.convertToCelsius()
                    weather.temp_maxMetric = weather.temp_max.convertToCelsius()
                    
                    weather.humidity = json["main"]["humidity"].intValue
                    
                    
                    weather.weather_id = json["weather"][0]["id"].stringValue
                    weather.weather_main = (json["weather"][0]["main"].stringValue).capitalizedString
                    weather.weather_desc = (json["weather"][0]["description"].stringValue).capitalizedString
                    weather.weather_icon = "\(openWeatherIcon)\(json["weather"][0]["icon"].stringValue).png"
                    
                    
                    let wind = unitName == "Imperial" ? json["wind"]["speed"].intValue : (json["wind"]["speed"].intValue).convertToMPH()
                    
                    weather.wind_speed = "\(wind) m/s"
                    weather.wind_speedMetric = "\(wind) miles/hour"
                    
                    weather.wind_direction = "\(json["wind"]["deg"].stringValue) °"
                    
                    
                    weather.pressure = "\(json["main"]["pressure"].stringValue) hPa"
                    
                    if(tmpDiffDay == diffDay){//for next 4 days
                        self.wi.dayWeatherColl.append(weather)
                        diffDay += 1
                    }
                    
                    //for today every 3 hours
                    if(tmpDiffDay == 0){
                        self.wi.hourWeatherColl.append(weather)
                        
                    }
                    
                    createUserdata(self.wi)
                }
                
                let date = NSDate()
                
                let localDate = self.dateFormatter.stringFromDate(date)
                self.wi.weatherTemp = (self.wi.hourWeatherColl.first?.temp)!
                self.wi.weatherTime = localDate.convertLocalHour()
                self.wi.weatherStatus = Int(self.wi.hourWeatherColl.first!.weather_id)!
                
                createUserdata(self.wi)
                
                self.tableView.reloadData()
                
            }
        }

    }
    func userLocationNotAllowed(locationName: String, coordinates:String){
    }
    func currentUserLocationNotRecognized(){
    }
}
