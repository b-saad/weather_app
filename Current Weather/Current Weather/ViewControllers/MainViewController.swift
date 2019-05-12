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

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet private var stackView: UIStackView!
    
    //Properties
    private let locationMangager = CLLocationManager()
    private var currentInfoEndPoint: CurrentWeatherEndPoint?
    private var fiveDayForecastEndpoint: FiveDayForecastEndpoint?
    private var fiveDayData: FiveDayForecast? {
        didSet { setFiveDayData() }
    }
    private var currentData: CurrentWeather? {
        didSet {
            setCurrentData()
            setCurrentDetailData()
        }
    }
    private var currentInfoView = CurrentInfoView()
    private var secondScreenView = SecondScreenView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMangager.delegate = self
        setupLocationServices()
        stackView.spacing = getTotalSafeAreaHeight()
        addViewsToStackView()
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
                if let fiveDayForecastEndpoint = fiveDayForecastEndpoint {
                    NetworkManager.shared.retrieveFiveDayForecastInfo(from: fiveDayForecastEndpoint) { fiveDayForecast in
                        self.fiveDayData = fiveDayForecast
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
            self.currentData = currently
            DispatchQueue.main.async {
//                guard let curTemp = currently.main.temp?.rounded() else { return }
//                if let country = currently.sys?.country, let cityName = currently.name  {
//                    self.locationLabel.text = "\(cityName), \(country)"
//                } else {
//                    self.locationLabel.text = "Could not load location name"
//                }
//                self.tempLabel.text = "\(curTemp)° C"
//                let windy = " and watch out, it is windy"
//                var recommendation: String = "";
//                if curTemp >= 30 {
//                    recommendation = "The least amount of clothing that is acceptable"
//                } else if curTemp >= 20 {
//                    recommendation = "A T-shirt and shorts if possible"
//                } else if curTemp >= 15 {
//                    recommendation = "Long Sleeves and pants are a verstaile choice for today"
//                } else if curTemp >= 10 {
//                    recommendation = "A light Jacket or sweater will come in handy"
//                } else if curTemp >= 3 {
//                    recommendation = "A moderate jacket and/or a sweater will serve you well"
//                } else if curTemp >= -2 {
//                        recommendation = "A thicker jacket and maybe a hat will serve you well"
//                } else if curTemp >= -10 {
//                    recommendation = "A winter jacket, gloves, and a hat"
//                } else if curTemp >= -25 {
//                    recommendation = "Layer on as much as possible, it's cold"
//                }
//
//                // 9 m/s is pretty windy
//                if let speed = currently.wind.speed {
//                    if speed > 9 {
//                        recommendation.append(windy)
//                    }
//                }
//
//                self.clothing.text = recommendation
//
//                if let couldPercentage = currently.clouds?.all {
//                    if couldPercentage < 25 {
//                        self.weatherSymbol.image = #imageLiteral(resourceName: "clear-day")
//                    } else if couldPercentage > 70 {
//                        self.weatherSymbol.image = #imageLiteral(resourceName: "few-clouds-day")
//                    } else {
//                        self.weatherSymbol.image = #imageLiteral(resourceName: "overcast")
//                    }
//                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        disableLocationServices()
    }
}

// MARK: Utility
private extension MainViewController {
    func sortFiveDayForecastData(fiveDayForecast: FiveDayForecast) ->  [Date : [List]] {
        var data: [Date : [List]] = [:]
        for listItem in fiveDayForecast.list {
            guard let listItem = listItem, let unixDate = listItem.dt else { continue }
            let date = Date(timeIntervalSince1970: unixDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let strippedDate = removeTimeStamp(fromDate: date)
            if !data.keys.contains(strippedDate) {
                data[strippedDate] = []
            }
            data[strippedDate]?.append(listItem)
        }
        return data
    }
    
    func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    func CreateFiveDayForecastUIDataModels(dates: [Date], data: [Date : [List]]) -> [DailyForecastQuickInfo] {
        var fiveDayForecastData: [DailyForecastQuickInfo] = []
        for date in dates {
            var high: Double = -Double.greatestFiniteMagnitude
            var low: Double = Double.greatestFiniteMagnitude
            guard let dayData = data[date] else { continue }
            for item in dayData {
                if let temp = item.main?.temp {
                    if temp > high { high = temp }
                    if temp < low { low = temp }
                }
            }
            fiveDayForecastData.append(DailyForecastQuickInfo(date: date, high: high, low: low))
        }
        return fiveDayForecastData
    }
}

struct DailyForecastQuickInfo {
    let date: Date
    let high: Double
    let low: Double
}

// MARK: Utility
private extension MainViewController {
    
    func getTotalSafeAreaHeight() -> CGFloat {
        let safeAreaTop: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        let safeAreaBottom: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return safeAreaTop + safeAreaBottom
    }
    
    func addViewsToStackView() {
        let height = UIScreen.main.bounds.height - getTotalSafeAreaHeight()
       
        currentInfoView.translatesAutoresizingMaskIntoConstraints = false
        currentInfoView.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(currentInfoView)
     
        secondScreenView.translatesAutoresizingMaskIntoConstraints = false
        secondScreenView.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(secondScreenView)
    }
    
    func setCurrentData() {
        guard let currentData = self.currentData else { return }
        let currentInfoItem = CurrentInfoItem(location: currentData.name, emoji: "🌇", temp: String(currentData.main.temp), description: "description")
        currentInfoView.set(data: currentInfoItem)
    }
    
    func setCurrentDetailData() {
        guard let currentData = self.currentData else { return }
        let currentDetailData = [
            CurrentInfoDetailItem(emoji: "🌇", detailItem: "Ball is: Life"),
            CurrentInfoDetailItem(emoji: "🌇", detailItem: "Ball is: Life"),
            CurrentInfoDetailItem(emoji: "🌇", detailItem: "Ball is: Life"),
            CurrentInfoDetailItem(emoji: "🌇", detailItem: "Ball is: Life")
        ]
        currentInfoView.setDetailData(data: currentDetailData)
    }
    
    func createSortedKeys(data: [Date : [List]]) -> [Date] {
        let keys = data.keys
        var sortedKeys = [Date]()
        sortedKeys = keys.sorted(by: { $0.compare($1) == .orderedAscending })
        sortedKeys.removeFirst()
        return sortedKeys
    }
    
    func setFiveDayData() {
        guard let data = fiveDayData else { return }
        let sortedData = sortFiveDayForecastData(fiveDayForecast: data)
        let sortedKeys = createSortedKeys(data: sortedData)
        let uiData = CreateFiveDayForecastUIDataModels(dates: sortedKeys, data: sortedData)
        secondScreenView.set(data: uiData)
    }
}

