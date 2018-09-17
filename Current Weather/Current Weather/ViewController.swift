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

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    // Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherSymbol: UIImageView!
    
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
                self.locationLabel.text = "\(currently.name), \(currently.sys.country)"
                self.tempLabel.text = "\(currently.main.temp.rounded())° C"
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

