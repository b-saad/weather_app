//
//  ViewController.swift
//  Current Weather
//
//  Created by Bilal Saad on 2018-09-15.
//  Copyright © 2018 Bilal Saad. All rights reserved.
//


// openWeatherMapAPIKey: "339a7e971419e55d3f22bb1aa8ce23f3"

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherSymbol: UIImageView!
    @IBOutlet weak var clothing: UILabel!
    
    //Properties
    var coordinates2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let locationMangager = CLLocationManager()
    let session: URLSession = .shared
    let openWeatherMapAPIKey: String = "339a7e971419e55d3f22bb1aa8ce23f3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMangager.delegate = self
        setupCoreLocation()
    }

    
    // Location Services
    func setupCoreLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationMangager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            enableLocationServices()
        default:
            break
        }
        
    }
    
    func enableLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationMangager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationMangager.startUpdatingLocation()
        }
    }
    
    func disableLocationServices() {
        locationMangager.stopUpdatingLocation()
    }
    
    // Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            break
        case .denied, .restricted:
            print("Denied")
        default:
            break
        }
    }
    
    
    // Weather API
    func getCurrentWeather() {

        
        let urlString = String(format: "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&type=accurate&units=metric&APPID=339a7e971419e55d3f22bb1aa8ce23f3", coordinates2D.latitude, coordinates2D.longitude)
        let url = URL(string: urlString)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("no data")
                return
            }
            
            guard let currently = try? decoder.decode(CurrentInfo.self, from: data) else {
                print(url)
                print ("Error: Could not decode data into main")
                return
            }
            
            DispatchQueue.main.async {
                let curTemp = currently.main.temp.rounded();
                self.locationLabel.text = "\(currently.name), \(currently.sys.country)"
                self.tempLabel.text = "\(curTemp)° C"
                let windy = " and watch out, it is windy"
                var recommendation: String = "";
                if curTemp >= 30 {
                    recommendation = "The least amount of clothing that is acceptable"
                } else if curTemp >= 20 {
                    recommendation = "A T-shirt and shorts if possible"
                } else if curTemp >= 15 {
                    recommendation = "Long Sleeves and pants are a verstaile choice for today"
                } else if curTemp >= 10 {
                    recommendation = "A light Jacket or sweater will come in handy"
                } else if curTemp >= 3 {
                    recommendation = "A moderate jacket and/or a sweater will serve you well"
                } else if curTemp >= -2 {
                        recommendation = "A thicker jacket and maybe a hat will serve you well"
                } else if curTemp >= -10 {
                    recommendation = "A winter jacket, gloves, and a hat"
                } else if curTemp >= -25 {
                    recommendation = "Layer on as much as possible, it's cold"
                }
                
                // 9 m/s is pretty windy
                if let speed = currently.wind.speed {
                    if speed > 9 {
                        recommendation.append(windy)
                    }
                }
                
                self.clothing.text = recommendation
                
                if currently.clouds.all < 25 {
                    self.weatherSymbol.image = #imageLiteral(resourceName: "clear-day")
                } else if currently.clouds.all > 70 {
                    self.weatherSymbol.image = #imageLiteral(resourceName: "few-clouds-day")
                } else {
                    self.weatherSymbol.image = #imageLiteral(resourceName: "overcast")
                }
                
            }
        }
        task.resume()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        coordinates2D.latitude = location.coordinate.latitude
        coordinates2D.longitude = location.coordinate.longitude
        disableLocationServices()
        getCurrentWeather()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

