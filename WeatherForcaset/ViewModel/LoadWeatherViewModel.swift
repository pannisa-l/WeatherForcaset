//
//  LoadWeather.swift
//  WeatherForcaset
//
//  Created by nisa.eem on 3/14/22.
//

import Foundation
import SwiftyJSON

class LoadWeatherViewModel : NSObject {
    
    let url : String = "https://api.openweathermap.org/data/2.5/"
    let apiKey : String = "631556fef5fc60966e29819bdd4a0bdf"
    var weatherItem = WeatherItem()
    var errorLoad = ErrorLoad()
    var fivedayForecast = [FivedayForecast]()
    var data : String = ""
    let dateFormatter = DateFormatter()
    let date = Date()
    
    func loadCurrentWeather(_ city: String,completeHandle: @escaping((_ weather: WeatherItem)->())){
        
        let newString = city.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        print("string \(newString)")
        
        let urlString = "\(self.url)weather?q=\(newString)&appid=\(self.apiKey)"
        
        Network.requestWithParameter(url: urlString, method: .get, params: nil) { (response, error) in
            if let error = error {
                print(error)
                return
            }
            else {
                if let response = response {
                    let responseString = String(data: response as! Data, encoding: .utf8)
                    self.data = responseString ?? ""
                    if self.data.contains("200") {
                        let decode = try! JSONDecoder().decode(WeatherItem.self, from:  self.data.data(using: .utf8)!)
                        
                        self.weatherItem = decode
                        print(self.weatherItem)
                        completeHandle(self.weatherItem)
                    } else {
                        let decode = try! JSONDecoder().decode(ErrorLoad.self, from:  self.data.data(using: .utf8)!)
                        self.errorLoad = decode
                        print(self.errorLoad)
                        completeHandle(WeatherItem())
                    }
                    
                }
            }
        }
    }
    
    func loadFivedayforecast(_ city: String,completeHandle: @escaping((_ weather: [FivedayForecast])->())) {
        
        let newString = city.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        print("string \(newString)")
        
        let urlString = "\(self.url)forecast?q=\(newString)&appid=\(self.apiKey)"
        self.dateFormatter.locale = Locale(identifier: "en")
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        Network.requestWithParameter(url: urlString, method: .get, params: nil) { (response, error) in
            if let error = error {
                print(error)
                return
            }
            else {
                if let response = response {
                    let responseString = String(data: response as! Data, encoding: .utf8)
                    self.data = responseString ?? ""
                    if self.data.contains("200") {
                        let forecastDecode = try! JSONDecoder().decode(WeatherForecast.self, from:  self.data.data(using: .utf8)!)
                        print(forecastDecode)
                        self.setDatainArray(forecastDecode, completeHandle: { data in
                            self.fivedayForecast = data
                        })
                        completeHandle(self.fivedayForecast)
                    }
                } else {
                    let decode = try! JSONDecoder().decode(ErrorLoad.self, from:  self.data.data(using: .utf8)!)
                    self.errorLoad = decode
                    print(self.errorLoad)
                    completeHandle([FivedayForecast]())
                }
            }
        }
    }
    
    
    func setDatainArray(_ forecastDecode: WeatherForecast,completeHandle: @escaping((_ fivedayForecast: [FivedayForecast])->())){
        
        var totalData = forecastDecode.list.count
        let loop = forecastDecode.list.count - 1
        print("loop = \(totalData)")
        
        var forecastmodelArray : [FivedayForecast] = []
        
        //day
        var currentDay = FivedayForecast(day: "", weatherData: [])
        var secondDay = FivedayForecast(day: "", weatherData: [])
        var thirdDay = FivedayForecast(day: "", weatherData: [])
        var fourthDay = FivedayForecast(day: "", weatherData: [])
        var fifthDay = FivedayForecast(day: "", weatherData: [])
        
        //data in day
        var weatherData : [WeatherData] = []
        var currentForecast : [WeatherData] = []
        var secondForecast : [WeatherData] = []
        var thirdForecast : [WeatherData] = []
        var fourthForecast : [WeatherData] = []
        var fifthForecast : [WeatherData] = []
        var sixthForecast : [WeatherData] = []
        
        for day in 0...loop {
            
            let temp = forecastDecode.list[day].main?.temp
            let descrip = forecastDecode.list[day].weather?[0].description
            let icon = forecastDecode.list[day].weather?[0].icon
            let dt_txt = forecastDecode.list[day].dt_txt
            
            let date = self.dateFormatter.date(from: forecastDecode.list[day].dt_txt ?? "")
            let calendar = Calendar.current
            let components = calendar.dateComponents([.weekday], from: date!)
            let weekdaycomponent = components.weekday! - 1
            
            let weekday = self.dateFormatter.weekdaySymbols[weekdaycomponent]
            let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
            let currentWeekDay = currentDayComponent.weekday! - 1
            let currentweekdaysymbol = self.dateFormatter.weekdaySymbols[currentWeekDay]
            
            if weekdaycomponent == currentWeekDay - 1 {
                totalData = totalData - 1
            }
            
            //add data in forecastDecode list
            if weekdaycomponent == currentWeekDay {
                let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                currentForecast.append(info)
                currentDay = FivedayForecast(day: currentweekdaysymbol, weatherData: currentForecast)
                weatherData.append(info)
            }
            if weekdaycomponent == currentWeekDay.increment(index: 1) {
                let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                secondForecast.append(info)
                secondDay = FivedayForecast(day: weekday, weatherData: secondForecast)
                weatherData.append(info)
            }
            if weekdaycomponent == currentWeekDay.increment(index: 2) {
                let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                thirdForecast.append(info)
                thirdDay = FivedayForecast(day: weekday, weatherData: thirdForecast)
                weatherData.append(info)
            }
            if weekdaycomponent == currentWeekDay.increment(index: 3) {
                let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                fourthForecast.append(info)
                fourthDay = FivedayForecast(day: weekday, weatherData: fourthForecast)
                weatherData.append(info)
            }
            if weekdaycomponent == currentWeekDay.increment(index: 4){
                let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                fifthForecast.append(info)
                fifthDay = FivedayForecast(day: weekday, weatherData: fifthForecast)
                weatherData.append(info)
            }
            if weekdaycomponent == currentWeekDay.increment(index: 5) {
                let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                sixthForecast.append(info)
                weatherData.append(info)
            }
            
            //check data in array = tatal data list
            if weatherData.count == totalData {
                //1 Day current
                if currentDay.weatherData.count > 0 {
                    forecastmodelArray.append(currentDay)
                }
                //2 Day
                if secondDay.weatherData.count > 0 {
                    forecastmodelArray.append(secondDay)
                }
                //3 Day
                if thirdDay.weatherData.count > 0 {
                    forecastmodelArray.append(thirdDay)
                }
                //4 Day
                if fourthDay.weatherData.count > 0 {
                    forecastmodelArray.append(fourthDay)
                }
                //5 Day
                if fifthDay.weatherData.count > 0 {
                    forecastmodelArray.append(fifthDay)
                }
                if forecastmodelArray.count <= 5 {
                    print(forecastmodelArray)
                    print(forecastmodelArray.count)
                    completeHandle(forecastmodelArray)
                }
            }
        }
        
    }
}
