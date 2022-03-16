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
//    var weatherForecast = WeatherForecast()
    var errorLoad = ErrorLoad()
    var data : String = ""
    let dateFormatter = DateFormatter()
    let date = Date()
    
    func loadCurrentWeather(_ city: String,completeHandle: @escaping((_ weather: WeatherItem)->())){
        
        let urlString = "\(self.url)weather?q=\(city)&appid=\(self.apiKey)"
      
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
    
    let urlString = "\(self.url)forecast?q=\(city)&appid=\(self.apiKey)"
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
                    
                   
                   
                    var totalData = forecastDecode.list.count
                    let loop = forecastDecode.list.count - 1
                    print("loop = \(totalData)")
                    
                    var forecastmodelArray : [FivedayForecast] = []
                    
                    var currentDayTemp = FivedayForecast(day: "", weatherData: [])
                    var secondDayTemp = FivedayForecast(day: "", weatherData: [])
                    var thirdDayTemp = FivedayForecast(day: "", weatherData: [])
                    var fourthDayTemp = FivedayForecast(day: "", weatherData: [])
                    var fifthDayTemp = FivedayForecast(day: "", weatherData: [])
                    var sixthDayTemp = FivedayForecast(day: "", weatherData: [])
                    var fetchedData : [WeatherData] = []
                    var currentDayForecast : [WeatherData] = []
                    var secondDayForecast : [WeatherData] = []
                    var thirddayDayForecast : [WeatherData] = []
                    var fourthDayDayForecast : [WeatherData] = []
                    var fifthDayForecast : [WeatherData] = []
                    var sixthDayForecast : [WeatherData] = []

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
                        
                        if weekdaycomponent == currentWeekDay {
                            let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                            currentDayForecast.append(info)
                            currentDayTemp = FivedayForecast(day: currentweekdaysymbol, weatherData: currentDayForecast)
                            print("1")
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 1) {
                            let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                            secondDayForecast.append(info)
                            secondDayTemp = FivedayForecast(day: weekday, weatherData: secondDayForecast)
                            print("2")
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 2) {
                            let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                            thirddayDayForecast.append(info)
                            print("3")
                            thirdDayTemp = FivedayForecast(day: weekday, weatherData: thirddayDayForecast)
                            fetchedData.append(info)
                        }
                        else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 3) {
                            let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                            fourthDayDayForecast.append(info)
                            print("4")
                            fourthDayTemp = FivedayForecast(day: weekday, weatherData: fourthDayDayForecast)
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 4){
                            let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                            fifthDayForecast.append(info)
                            fifthDayTemp = FivedayForecast(day: weekday, weatherData: fifthDayForecast)
                            fetchedData.append(info)
                            print("5")
                        }
                        else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 5) {
                            let info = WeatherData(temp: temp, description: descrip, icon: icon, date: dt_txt)
                            sixthDayForecast.append(info)
                            sixthDayTemp = FivedayForecast(day: weekday, weatherData: sixthDayForecast)
                            fetchedData.append(info)
                            print("6")
                        }
                        
                        if fetchedData.count == totalData {
                            
                            if currentDayTemp.weatherData.count > 0 {
                                forecastmodelArray.append(currentDayTemp)
                            }
                            
                            if secondDayTemp.weatherData.count > 0 {
                                forecastmodelArray.append(secondDayTemp)
                            }
                            
                            if thirdDayTemp.weatherData.count > 0 {
                                forecastmodelArray.append(thirdDayTemp)
                            }
                            
                            if fourthDayTemp.weatherData.count > 0 {
                                forecastmodelArray.append(fourthDayTemp)
                            }
                            
                            if fifthDayTemp.weatherData.count > 0 {
                                forecastmodelArray.append(fifthDayTemp)
                            }
                            
//                            if sixthDayTemp.weatherData.count > 0 {
//                                forecastmodelArray.append(sixthDayTemp)
//                            }
//
                            if forecastmodelArray.count <= 5 {
                                print(forecastmodelArray)
                                print(forecastmodelArray.count)
                                completeHandle(forecastmodelArray)
                            }
                        }
                    }
                } else {
                    let decode = try! JSONDecoder().decode(ErrorLoad.self, from:  self.data.data(using: .utf8)!)
                    self.errorLoad = decode
                    print(self.errorLoad)
//                completeHandle(WeatherForecast())
                }
            }
        }
        
       
        
    }
}
    
}

//init(json: [String: Any]) {
//    self.name = json["name"] as? String
//    self.weather = json["weather"] as? [Weather] ?? []
//    self.main = json["main"] as? Main
//}
extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}
