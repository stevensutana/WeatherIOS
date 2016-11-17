//
//  Userdata.swift
//  Weather
//
//  Created by Steven Sutana on 11/15/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import RealmSwift
let realm = try! Realm()
var weatherList:Results<Weather>?

func refreshArray() {
    weatherList=getUserdataResult()
}

func migrationUserdata() {
    Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
}

func migrationUserdataManually() {
    guard let path = Realm.Configuration.defaultConfiguration.fileURL?.absoluteString else {
        fatalError("no realm path")
    }
    
    do {
        try NSFileManager().removeItemAtPath(path)
    } catch {
        fatalError("couldn't remove at path")
    }
}

func celarUserdata(){
    try! realm.write({ () -> Void in
        realm.deleteAll()
    })
}

func getUserdataResult() -> Results<Weather>{
    return realm.objects(Weather.self)
}

func getUserdata() -> [Weather] {
    let weatherInfoColl = Array(realm.objects(Weather.self))
    return weatherInfoColl
}


func getSpecificdata(index:Int) -> Weather {
    let weatherInfoColl = Array(realm.objects(Weather.self))
    
    return weatherInfoColl[index]
}

func getDataHour(index:Int) -> List<WeatherInfo> {
    let weatherInfoColl = Array(realm.objects(Weather.self))
    
    return weatherInfoColl[index].hourWeatherColl
}

//update whole reference
func addUserdata(wi:Weather) {
    try! realm.write({ () -> Void in
        realm.add([wi], update: true)
    })
}

//update half reference
func createUserdata(wi:Weather) {
    try! realm.write({ () -> Void in
        realm.create(Weather.self, value: wi, update: true)
    })
}
func deleteUserdata(wi:Weather) {
    try! realm.write {
        realm.delete(wi)
    }
}

func saveData(result:Results<Weather>) {
    try! realm.write({ () -> Void in
        realm.create(Weather.self, value: result, update: true)
    })
}
func sortAndUpdateLocal() {
    weatherList = realm.objects(Weather.self).sorted("weatherCity")
}
//func getNextKey()->Int{
//    let myvalue = realm.objects(Weather).map{$0.weatherId}.maxElement() ?? 0
//    return myvalue+1
//}