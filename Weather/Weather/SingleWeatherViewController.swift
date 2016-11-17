//
//  SingleWeatherViewController.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit
import Gifu
import RealmSwift

class SingleWeatherViewController: UIViewController{
    
    //start IBOutlet
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var descWeatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundGif: AnimatableImageView!
    let userLocation = ModuleLocation()
    var userLocationName :String?
    var local:Bool=false
    let date = NSDate()
    let dateFormatter = NSDateFormatter()
    var indexGlobal = 0
    
    let dayWeatherColl = List<WeatherInfo>()
    var hourWeatherColl = List<WeatherInfo>()
    
    var isCheck = false
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleWeatherDelegate = self
        userLocation.delegate = self
        
        if(isCheck){
            userLocation.checkLocationNow()
        }
        
    
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
        dateFormatter.timeZone = NSTimeZone()
        
        // Do any additional setup after loading the view.
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
    
    func setGifBackground(status:String){
        
        let status_weather = Int(status)
        let mod_status = status_weather! / 100 //getting group of weather
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
        
        
        UIView.transitionWithView(self.backgroundGif,
                                  duration:0.2,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations: {
                                    self.backgroundGif.animateWithImage(named: gifName)
                                    },
                                  completion: {(finished:Bool) -> Void in
                                    
                                    if(finished){
                                        
                                        self.backgroundGif.startAnimatingGIF()
                                    }
                                    
        })
    }
    
    func setupUI(){
        
        self.collectionView.reloadData()
        
        self.tableView.reloadData()
        
        self.locationLabel.animateWithText(self.userLocationName!)
        self.todayLabel.animateWithText(self.date.dayOfTheWeek()!)
        self.today.animateWithText("Today")
        
        self.degreeLabel.animateWithText(unitName == "Imperial" ? "\(self.hourWeatherColl[0].temp)" : "\(self.hourWeatherColl[0].tempMetric)")
        
        self.tempMaxLabel.animateWithText(unitName == "Imperial" ? "\(self.hourWeatherColl[0].temp_max)" : "\(self.hourWeatherColl[0].temp_maxMetric)")
        self.tempMinLabel.animateWithText(unitName == "Imperial" ? "\(self.hourWeatherColl[0].temp_min)" : "\(self.hourWeatherColl[0].temp_minMetric)")
        
        self.weatherLabel.animateWithText(self.hourWeatherColl[0].weather_desc)
        
        let descriptionWeather = unitName == "Imperial" ? "Today condition: \(self.hourWeatherColl[0].weather_desc). The high will be \(self.hourWeatherColl[0].temp_max) and the low will be \(self.hourWeatherColl[0].temp_min)." : "Today condition: \(self.hourWeatherColl[0].weather_desc). The high will be \(self.hourWeatherColl[0].temp_maxMetric) and the low will be \(self.hourWeatherColl[0].temp_minMetric)."
        
        self.descWeatherLabel.animateWithText(descriptionWeather)
        
        self.humidityLabel.animateWithText("\(self.hourWeatherColl[0].humidity) %")
        self.pressureLabel.animateWithText(self.hourWeatherColl[0].pressure)
        
        let wind = unitName == "Imperial" ? self.hourWeatherColl[0].wind_speed : self.hourWeatherColl[0].wind_speedMetric
        self.windLabel.animateWithText(wind)
        self.setGifBackground(self.hourWeatherColl[0].weather_id)
    }

    func setupUILocal(index:Int){
        indexGlobal = index
        local = true
        self.locationLabel.animateWithText((weatherList?[index].weatherCity)!)
        self.todayLabel.animateWithText(self.date.dayOfTheWeek()!)
        self.today.animateWithText("Today")
        
        self.degreeLabel.animateWithText(unitName == "Imperial" ? "\((weatherList?[index].hourWeatherColl[0].temp)!)" : "\((weatherList?[index].hourWeatherColl[0].tempMetric)!)")
        self.tempMaxLabel.animateWithText(unitName == "Imperial" ? "\((weatherList?[index].hourWeatherColl[0].temp_max)!)" : "\((weatherList?[index].hourWeatherColl[0].temp_maxMetric)!)")
        self.tempMinLabel.animateWithText(unitName == "Imperial" ? "\((weatherList?[index].hourWeatherColl[0].temp_min)!)" : "\((weatherList?[index].hourWeatherColl[0].temp_minMetric)!)")
        
        self.weatherLabel.animateWithText((weatherList?[index].hourWeatherColl[0].weather_desc)!)
        
        let descriptionWeather = unitName == "Imperial" ? "Today condition: \((weatherList?[index].hourWeatherColl[0].weather_desc)!). The high will be \((weatherList?[index].hourWeatherColl[0].temp_max)!) and the low will be \((weatherList?[index].hourWeatherColl[0].temp_min)!)." : "Today condition: \((weatherList?[index].hourWeatherColl[0].weather_desc)!). The high will be \((weatherList?[index].hourWeatherColl[0].temp_maxMetric)!) and the low will be \((weatherList?[index].hourWeatherColl[0].temp_minMetric)!)."
        
        self.descWeatherLabel.animateWithText(descriptionWeather)
        
        self.humidityLabel.animateWithText("\((weatherList?[index].hourWeatherColl[0].humidity)!) %")
        self.pressureLabel.animateWithText((weatherList?[index].hourWeatherColl[0].pressure)!)
        
        let wind = unitName == "Imperial" ? weatherList?[index].hourWeatherColl[0].wind_speed : weatherList?[index].hourWeatherColl[0].wind_speedMetric
        self.windLabel.animateWithText(wind!)
        self.setGifBackground((weatherList?[index].hourWeatherColl[0].weather_id)!)
        
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
}

extension SingleWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherDayTableViewCell", forIndexPath: indexPath) as! WeatherDayTableViewCell
        
        if (local) {
            cell.SetUpCell((weatherList?[indexGlobal].dayWeatherColl[indexPath.row])!)
        } else {
            cell.SetUpCell(self.dayWeatherColl[indexPath.row])
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (local) {
            return (weatherList?[indexGlobal].dayWeatherColl.count)!
        } else {
            return self.dayWeatherColl.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.height*0.25
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SingleWeatherViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    //MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (local) {
            return (weatherList?[indexGlobal].hourWeatherColl.count)!
        } else {
            return self.hourWeatherColl.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherTimeCollectionViewCell", forIndexPath: indexPath) as! WeatherTimeCollectionViewCell
        
        let index = indexPath.row
        if (local) {
            cell.SetUpCell(index,Weather: (weatherList?[indexGlobal].hourWeatherColl[index])!)
        } else {
            cell.SetUpCell(index,Weather: self.hourWeatherColl[indexPath.row])
        }
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width*0.15, height: collectionView.frame.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return collectionView.frame.size.width*0.25
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    //MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }
}

extension SingleWeatherViewController:ModuleLocationDelegate{
    
    func currentUserLocationIs(locationName: String, coordinates:String){
        checkLocation = false
        userLocationName = locationName
        
        
        GetWeather(userLocationName!, unit: "Metric"){(responseObject,statusCode,error) in
            if(error == nil){
                
                var diffDay : Int = 1
                let jsonArr = responseObject!["list"].arrayValue
                for json in jsonArr{
                    let weather = WeatherInfo()
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
                    let tmpDiffDay = self.date.daysFrom(weather.dt)
                    
                    if(tmpDiffDay == diffDay){//for next 4 days
                        self.dayWeatherColl.append(weather)
                        diffDay += 1
                    }
                    
                    //for today every 3 hours
                    if(tmpDiffDay == 0){
                        self.hourWeatherColl.append(weather)
                    }
                }
                self.setupUI()
            }
        }
        
    }
    func userLocationNotAllowed(locationName: String, coordinates:String){
}
    func currentUserLocationNotRecognized(){
}
}

extension SingleWeatherViewController : SingleWeatherDelegate{
    func GetData(index: Int) {
        setupUILocal(index)
    }
}
