//
//  ViewController.swift
//  WeatherForcaset
//
//  Created by nisa.eem on 3/14/22.
//

import UIKit
import Kingfisher

class CurrentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var viewScreen: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempData: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityData: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rightPageButton: UIButton!
    @IBOutlet weak var descripWeatherLabel: UILabel!
    @IBOutlet weak var changTampButton: UIButton!
    
    private var viewmodel = LoadWeatherViewModel()
    
    var weatherItem = WeatherItem()
    var fivedayForecast = FivedayForecast()
    var city : String = "Bangkok"
    var temp : Int = 0
    var dateCurrent : String = ""
    var idIcon : String = ""
    var imgIcon: UIImage?
    var celsius = true
    let dateFormatter = DateFormatter()
    let date = Date()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        hideKeyboardWhenTappedAround()
        searchTextField.delegate = self
        searchTextField.clearButtonMode = .whileEditing
        self.getCurrentWeather(self.city)
        self.setView()
        
        for family in UIFont.familyNames {

            let sName: String = family as String
            print("family: \(sName)")
                    
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
    }
    
    func setView(){
        //set font and color
        self.titleLabel.text = "Weather"
        self.titleLabel.font = UIFont(name: "Montserrat Black", size: 45)
      
        self.rightPageButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        self.rightPageButton.tintColor = UIColor(named: "buttonTemp")
        self.rightPageButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        self.changTampButton.setTitle("°F", for: .normal)
        self.changTampButton.backgroundColor = UIColor(named: "buttonTemp")
        self.changTampButton.setTitleColor(UIColor.white, for: .normal)
        self.changTampButton.layer.cornerRadius = self.changTampButton.frame.size.height/2
        self.changTampButton.clipsToBounds = true

        self.searchTextField.placeholder = "Ex. London"
        self.searchTextField.font = UIFont(name: "Montserrat Light", size: 18)
        
        self.searchButton.setTitle("Search", for: .normal)
        self.searchButton.setTitleColor(UIColor.white, for: .normal)
        self.searchButton.backgroundColor = UIColor(named: "buttonTemp")
        self.searchButton.layer.cornerRadius = self.searchButton.frame.size.height/3
        
        self.searchButton.clipsToBounds = true


        self.cityLabel.font = UIFont(name: "Montserrat Bold", size: 30)
        self.dateLabel.font = UIFont(name: "Montserrat Light", size: 20)
        
// 
//        self.imageWeather.layer.borderColor = UIColor(named: "BorderImg")?.cgColor
//        self.imageWeather.layer.borderWidth = 3
//        self.imageWeather.layer.cornerRadius = self.imageWeather.frame.height / 2
//        self.imageWeather.clipsToBounds = true
        
        self.tempLabel.text = "Temperature"
        self.humidityLabel.text = "Humidity"
        self.tempLabel.font = UIFont(name: "Montserrat Medium", size: 20)
        self.humidityLabel.font = UIFont(name: "Montserrat Medium", size: 20)
        self.dateLabel.font = UIFont(name: "Montserrat Light", size: 20)
        self.weatherStatus.font = UIFont(name: "Montserrat Bold", size: 22)
        self.descripWeatherLabel.font = UIFont(name: "Montserrat Light", size: 18)
        self.tempData.font = UIFont(name: "Montserrat Medium", size: 25)
        self.humidityData.font = UIFont(name: "Montserrat Medium", size: 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor.blue.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 3.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func getCurrentWeather(_ city: String){
        viewmodel.loadCurrentWeather(city, completeHandle: { (data) in
            self.weatherItem = data
            
            if self.weatherItem.cod == 200 {
                self.idIcon = self.weatherItem.weather?[0].icon ?? ""
                self.getIcon(self.idIcon)
                
                self.city = "\(self.weatherItem.name ?? "")"
                self.cityLabel.text = self.city
                self.descripWeatherLabel.text = "\(self.weatherItem.weather?[0].description ?? "")"
                
                self.dateFormatter.locale = Locale(identifier: "en")
                self.dateFormatter.dateFormat = "EEEE d MMMM yyyy"
                self.dateCurrent = self.dateFormatter.string(from: self.date)
                self.dateLabel.text = self.dateCurrent
                
                self.weatherStatus.text = "\(self.weatherItem.weather?[0].main ?? "")"
                self.temp = Int((self.weatherItem.main?.temp ?? 0.0) - 273.15)
                self.tempData.text = "\(self.temp)°C"
                self.humidityData.text = "\(self.weatherItem.main?.humidity ?? 0)%"
            } else {
                self.showToast(message: "ไม่พบข้อมูล", seconds: 3.0)
            }
        })
    }
    
    func getIcon(_ id:String){
        let url = URL(string: "https://openweathermap.org/img/wn/\(id)@4x.png")
        self.imageWeather.kf.setImage(with: url)
    }
    
    @IBAction func changTemp(_ sender: Any) {
        if self.celsius == true {
        self.celsius = false
        let tempChangButton = Int((self.temp*9)/5 + 32)
        self.tempData.text = "\(tempChangButton)°F"
            self.temp = tempChangButton
            self.changTampButton.setTitle("°C", for: .normal)
        }else{
            self.celsius = true
            let tempChangButton = Int((self.temp - 32)*5/9)
            self.tempData.text = "\(tempChangButton)°C"
            self.temp = tempChangButton
            self.changTampButton.setTitle("°F", for: .normal)
        }
    }

    
    @IBAction func nextToFiveday(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FivedayForecast", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "FivedayForecastViewController") as! FivedayForecastViewController
        let fiveDayController = UINavigationController.init(rootViewController: destinationVC)
        destinationVC.city = self.city
        destinationVC.celsius = self.celsius
        destinationVC.dateCurrent = self.dateCurrent
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.viewScreen.window!.layer.add(transition, forKey: kCATransition)
        fiveDayController.modalPresentationStyle = .fullScreen
        self.present(fiveDayController, animated: false, completion: nil)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        self.city = self.searchTextField.text ?? ""
        getCurrentWeather(self.city)
        self.searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.city = textField.text ?? ""
        getCurrentWeather(self.city)
        print("\(self.city)")
        textField.resignFirstResponder()
        return true
    }
 
}

