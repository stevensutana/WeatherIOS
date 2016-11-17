//
//  WeatherProtocol.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

protocol WeatherDelegate {
    func AddFirstWeather()
    func AddWeather()
    func ReloadWeathers()
}

extension WeatherDelegate {
    func AddFirstWeather(){}
    func AddWeather(){
        // leaving this empty
    }
    func ReloadWeathers(){
    }
}

protocol WeatherPageDelegate {
    func AddView()
    func SetView(index:Int)
    func DeleteView(index:Int)
}

extension WeatherPageDelegate {
    func AddView(){
        // leaving this empty
    }
    
    func SetView(index:Int){
    
    }
    
    
    func DeleteView(index:Int){
    
    }
}

protocol SingleWeatherDelegate {
    func GetData(index:Int)
}
// ------------------------------------- Function --------------------------------------- //

var weaherDelegate : WeatherDelegate? = nil
var weatherPageDelegate : WeatherPageDelegate? = nil
var singleWeatherDelegate : SingleWeatherDelegate? = nil

func AddWeatherDelegate() {
    if let wd = weaherDelegate {
        wd.AddWeather()
    }
}

func AddFirstWeatherDelegate() {
    if let wd = weaherDelegate {
        wd.AddFirstWeather()
    }
}

func AddViewDelegate(){
    if let wd = weatherPageDelegate{
        wd.AddView()
    }
}

func SetViewDelegate(index:Int){
    if let wd = weatherPageDelegate{
        wd.SetView(index)
    }
}


func DeleteViewDelegate(index:Int){
    if let wd = weatherPageDelegate{
        wd.DeleteView(index)
    }
}

func GetDataDelegate(index:Int){
    if let wd = singleWeatherDelegate{
        wd.GetData(index)
    }
}

func ReloadWeathersDelegate(){
    
    if let wd = weaherDelegate {
        wd.ReloadWeathers()
    }

}
    
// ------------------------------------------------------------------------------------- //