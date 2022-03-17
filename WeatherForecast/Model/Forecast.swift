//
//  forecast.swift
//  WeatherForcaset
//
//  Created by nisa.eem on 3/15/22.
//

import Foundation
import SwiftyJSON


struct WeatherData: Codable{
    let temp: Double?
    let description: String?
    let icon: String?
    let date: String?
}

struct FivedayForecast: Codable{
    
    var day: String?
    var weatherData : [WeatherData] = []

}

struct WeatherForecast : Codable {
    
    var city : City?
    var list : [List] = []
    
}

struct City : Codable {
    
    var name: String?
    
}

struct List : Codable {
    
    var main: MainForecast?
    var weather: [WeatherFiveday]?
    var dt_txt: String?
    
}

struct MainForecast : Codable {
    
    var humidity: Int?
    var temp: Double?
    
}

struct WeatherFiveday: Codable {
    
    var id : Int?
    var main: String?
    var description : String?
    var icon : String?
    
}
