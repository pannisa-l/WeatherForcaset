//
//  Model.swift
//  WeatherForcaset
//
//  Created by nisa.eem on 3/14/22.
//

import Foundation
import SwiftyJSON


struct ErrorLoad: Codable {
    var cod : String?
    var message : String?
}

struct WeatherItem : Codable {
    var name : String? = ""
    var weather: [Weather]? = []
    var main : Main?
    var cod : Int? = 0
    var sys: Sys?
}

struct Weather : Codable  {
    var id : Int?
    var main: String?
    var description : String?
    var icon : String?
}

struct Sys : Codable  {
    var country : String?
}

struct Main : Codable  {
    var humidity: Int?
    var grnd_level: Int?
    var temp_max: Double?
    var temp_min: Double?
    var feels_like: Double?
    var pressure: Double?
    var sea_level: Double?
    var temp: Double?
}
