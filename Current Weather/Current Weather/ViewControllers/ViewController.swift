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
    let locationMangager = CLLocationManager()
    private var currentInfoEndPoint: CurrentWeatherEndPoint?
    private var fiveDayForecastEndpoint: FiveDayForecastEndpoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMangager.delegate = self
        setupLocationServices()
    }
    
    // Location Services
    func setupLocationServices() {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationMangager.requestWhenInUseAuthorization()
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
                guard let location = locationMangager.location else { break }
                currentInfoEndPoint = CurrentWeatherEndPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                fiveDayForecastEndpoint = FiveDayForecastEndpoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                if let currentInfoEndPoint = currentInfoEndPoint {
                    getCurrentWeather(endPoint: currentInfoEndPoint)
                }
                if let endpoint = fiveDayForecastEndpoint {
                    NetworkManager.shared.retrieveFiveDayForecastInfo(from: endpoint) { FiveDayForecast in
                        /// - TODO: PROCESS 5 DAY FORECAST DATA
                    }
                }
            case .denied, .restricted:
                print("Denied")
            default:
                break
        }
    }
    
    
    // Weather API
    func getCurrentWeather(endPoint: CurrentWeatherEndPoint) {
        NetworkManager.shared.retrieveCurrentWeatherInfo(from: endPoint) { currently in
            DispatchQueue.main.async {
                guard let curTemp = currently.main.temp?.rounded() else { return }
                if let country = currently.sys?.country, let cityName = currently.name  {
                    self.locationLabel.text = "\(cityName), \(country)"
                } else {
                    self.locationLabel.text = "Could not load location name"
                }
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
                
                if let couldPercentage = currently.clouds?.all {
                    if couldPercentage < 25 {
                        self.weatherSymbol.image = #imageLiteral(resourceName: "clear-day")
                    } else if couldPercentage > 70 {
                        self.weatherSymbol.image = #imageLiteral(resourceName: "few-clouds-day")
                    } else {
                        self.weatherSymbol.image = #imageLiteral(resourceName: "overcast")
                    }
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        disableLocationServices()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

