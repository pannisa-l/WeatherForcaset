//
//  FivedayForecastViewController.swift
//  WeatherForcaset
//
//  Created by nisa.eem on 3/16/22.
//

import UIKit

class FivedayForecastViewController: UIViewController {

    @IBOutlet var viewScreen: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeCurrent: UILabel!
    
    private var viewmodel = LoadWeatherViewModel()
    
    var fivedayForecast = [FivedayForecast]()
    var city: String = ""
    var celsius : Bool = true
    var dateCurrent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setBar()
        self.navigationItem.title = "5-days forecast"
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat Bold", size: 20)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        self.setBar()
        print("date current \(dateCurrent)")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.reloadData()
        
        self.loadFiveday(self.city)
        
        cityLabel.text = self.city
        cityLabel.font = UIFont(name: "Montserrat Black", size: 25)
        self.timeCurrent.text = self.dateCurrent
        timeCurrent.font = UIFont(name: "Montserrat Thin", size: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        setGradientBackground()
        
        super.viewWillAppear(animated)
    }
    
    func loadFiveday(_ city: String){
       
        viewmodel.loadFivedayforecast(city, completeHandle: { (data) in
            self.fivedayForecast = data
            print("five \(self.fivedayForecast.count)")
            self.tableView.reloadData()

        })
        
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 10.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    private func setBar(){

        let backImage = UIImage(systemName: "arrow.left")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))

        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(backImage, for: .normal)
        button.frame = CGRect(x: 0.0, y: 14, width: 20, height: 15)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.tintColor = UIColor.black
        view.addSubview(button)
        let leftBarButtonItem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc func back() {
//        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vcCurrent = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
            let currentViewController = UINavigationController.init(rootViewController: vcCurrent)
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            self.viewScreen.window!.layer.add(transition, forKey: kCATransition)
            currentViewController.modalPresentationStyle = .fullScreen
            self.present(currentViewController, animated: false, completion: nil)
        })

    }

}
extension FivedayForecastViewController : UITableViewDataSource,UITableViewDelegate {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fivedayForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FivedayForecastCell", for: indexPath) as! FivedayForecastTableViewCell
        cell.setData(self.fivedayForecast[indexPath.item],self.celsius)
        
        return cell
    }

}
