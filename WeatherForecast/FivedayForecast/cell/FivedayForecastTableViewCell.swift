//
//  FivedayForecastTableViewCell.swift
//  WeatherForcaset
//
//  Created by nisa.eem on 3/16/22.
//

import UIKit
import Kingfisher

class FivedayForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeSet1: UILabel!
    @IBOutlet weak var timeSet2: UILabel!
    @IBOutlet weak var timeSet3: UILabel!
    @IBOutlet weak var timeSet4: UILabel!
    @IBOutlet weak var imgSet1: UIImageView!
    @IBOutlet weak var imgSet2: UIImageView!
    @IBOutlet weak var imgSet3: UIImageView!
    @IBOutlet weak var imgSet4: UIImageView!
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var temp3: UILabel!
    @IBOutlet weak var temp4: UILabel!
    
    var index : Int = 0
    var loop : Int = 0
    var celsius : Bool = true
    var time : String = ""
    var id : String = ""
    var temp : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setView(){
     
        viewBG.backgroundColor = UIColor.white
        viewBG.clipsToBounds = true
        viewBG.backgroundColor = .white
        
        viewBG.layer.cornerRadius = 12
        viewBG.layer.shadowColor = UIColor.gray.cgColor
        viewBG.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        viewBG.layer.shadowRadius = 12.0
        viewBG.layer.shadowOpacity = 0.7
        
        viewBG.layer.borderColor = UIColor.gray.cgColor
        viewBG.layer.borderWidth = 0.2
        
        self.dayLabel.font = UIFont(name: "Montserrat Medium", size: 25)
        self.timeSet1.font = UIFont(name: "Montserrat Light", size: 18)
        self.timeSet2.font = UIFont(name: "Montserrat Light", size: 18)
        self.timeSet3.font = UIFont(name: "Montserrat Light", size: 18)
        self.timeSet4.font = UIFont(name: "Montserrat Light", size: 18)
        self.temp1.font = UIFont(name: "Montserrat Light", size: 15)
        self.temp2.font = UIFont(name: "Montserrat Light", size: 15)
        self.temp3.font = UIFont(name: "Montserrat Light", size: 15)
        self.temp4.font = UIFont(name: "Montserrat Light", size: 15)
            
    }
    
    func setData(_ data:FivedayForecast,_ celsius: Bool) {
        self.dayLabel.text = data.day
        self.celsius = celsius
        loop = data.weatherData.count - 1
        print("loop \(loop)")
        for _ in 0...loop {
            if self.index <= loop {
                if self.index == 0 {
                    let time = "\(data.weatherData[self.index].date ?? "")"
                    let id = "\(data.weatherData[self.index].icon ?? "")"
                    let temp = data.weatherData[self.index].temp ?? 0.0
                    let url = URL(string: "https://openweathermap.org/img/wn/\(id)@4x.png")
                    
                    self.dayLabel.text = "\(data.day ?? "")"
                    self.getTime(date: time,completeHandle: { time in
                        self.timeSet1.text = time
                    })
                    self.imgSet1.kf.setImage(with: url)
                    self.convertTemp(data: temp, completeHandle: { tempConvert in
                        self.temp1.text = tempConvert
                    })
                    self.index = self.index + 2
                }
                else if self.index == 2 {
                    let time = "\(data.weatherData[self.index].date ?? "")"
                    let id = "\(data.weatherData[self.index].icon ?? "")"
                    let url = URL(string: "https://openweathermap.org/img/wn/\(id)@4x.png")
                    let temp = data.weatherData[self.index].temp ?? 0.0

                    self.dayLabel.text = "\(data.day ?? "")"
                    self.getTime(date: time,completeHandle: { time in
                        self.timeSet2.text = time
                    })
                    self.imgSet2.kf.setImage(with: url)
                    self.convertTemp(data: temp, completeHandle: { tempConvert in
                        self.temp2.text = tempConvert
                    })
                    self.index = self.index + 2
                }
                else if self.index == 4 {
                    let time = "\(data.weatherData[self.index].date ?? "")"
                    let id = "\(data.weatherData[self.index].icon ?? "")"
                    let url = URL(string: "https://openweathermap.org/img/wn/\(id)@4x.png")
                    let temp = data.weatherData[self.index].temp ?? 0.0

                    self.dayLabel.text = "\(data.day ?? "")"
                    self.getTime(date: time,completeHandle: { time in
                        self.timeSet3.text = time
                    })
                    self.imgSet3.kf.setImage(with: url)
                    self.convertTemp(data: temp, completeHandle: { tempConvert in
                        self.temp3.text = tempConvert
                    })
                    self.index = self.index + 2
                }
                else if index == 6 {
                    let time = "\(data.weatherData[self.index].date ?? "")"
                    let id = "\(data.weatherData[self.index].icon ?? "")"
                    let url = URL(string: "https://openweathermap.org/img/wn/\(id)@4x.png")
                    let temp = data.weatherData[self.index].temp ?? 0.0

                    self.dayLabel.text = "\(data.day ?? "")"
                    self.getTime(date: time,completeHandle: { time in
                        self.timeSet4.text = time
                    })
                    self.convertTemp(data: temp, completeHandle: { tempConvert in
                        self.temp4.text = tempConvert
                    })
                    self.imgSet4.kf.setImage(with: url)
                    self.index = self.index + 2
                }
            } else{
                if self.temp2.text == "" {
                    self.temp2.text = ""
                    self.timeSet2.text = ""
                } else if self.temp3.text == "" {
                    self.temp3.text = ""
                    self.timeSet3.text = ""
                } else if self.temp4.text == "" {
                    self.temp4.text = ""
                    self.timeSet4.text = ""
                }
            }
        }
    }
    
    func getTime(date: String,completeHandle: @escaping((_ date: String)->())) {
        let dateArray = date.components(separatedBy: " ")
        let time = dateArray[1].components(separatedBy: ":")
        let timeMinutes = time[0] + ":" + time[1]
        completeHandle(timeMinutes)
    }
    
    func convertTemp(data: Double,completeHandle: @escaping((_ temp: String)->())) {
        var tepmConvert : String = ""
        if self.celsius == true {
            tepmConvert = "\(Int(data - 273.15))°C"
        } else {
            tepmConvert = "\(Int((data*9)/5 - 459.67))°F"
        }
        completeHandle(tepmConvert)
    }
}
