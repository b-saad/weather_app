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
    @IBOutlet private var scrollView: UIScrollView!
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
    private var indexOfViewBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMangager.delegate = self
        scrollView.delegate = self
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
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        disableLocationServices()
    }
}

struct DailyForecastQuickInfo {
    let date: Date
    let high: Double
    let low: Double
}

// MARK: Data Utility
/// TODO: Seperate into datacontroller
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
    
    func removeDate(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.hour, .minute], from: fromDate)) else {
            fatalError("Failed to strip date from Date object")
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
    
    func setCurrentData() {
        guard let currentData = self.currentData else { return }
        let description = createDescription(temp: currentData.main.temp, windSpeed: currentData.wind.speed, rainAmount: currentData.rain?.oneH, cloudPercentage: currentData.clouds?.all)
        let currentInfoItem = CurrentInfoItem(location: currentData.name, emoji: "🌇", temp: String(Int(currentData.main.temp.rounded())), description: description)
        currentInfoView.set(data: currentInfoItem)
    }
    
    func createDescription(temp: Double, windSpeed: Double?, rainAmount: Double?, cloudPercentage: Int?) -> String {
        let windyDescription = " and watch out, it's windy.\n"
        var itemsToBring = "\nConsider using/bringing:\n - sunscreen\n"
        var description: String = "";
        if temp >= 30 {
            description = "The least amount of clothing that is acceptable"
        } else if temp >= 20 {
            description = "A T-shirt and shorts if possible"
        } else if temp >= 15 {
            description = "Long Sleeves and pants are a verstaile choice for today"
        } else if temp >= 10 {
            description = "A light Jacket or sweater will come in handy"
        } else if temp >= 3 {
            description = "A moderate jacket and/or a sweater will serve you well"
        } else if temp >= -2 {
                description = "A thicker jacket and maybe a hat will serve you well"
        } else if temp >= -10 {
            description = "A winter jacket, gloves, boots, and a hat"
        } else if temp >= -25 {
            description = "Layer on as much as possible, it's cold. Better yet stay inside."
        }

        // 9 m/s is pretty windy
        if let speed = windSpeed {
            if speed > 9 {
                description.append(windyDescription)
            }
        }
        
        if let rain = rainAmount {
            if rain > 0 {
                itemsToBring += " - an unbrellla\n"
            }
        }
        
        if let clouds = cloudPercentage {
            if clouds < 30 {
                itemsToBring += " - sunglasses\n"
            }
        }
        
        itemsToBring.removeLast()
        description += itemsToBring
        return description
    }
    
    func setCurrentDetailData() {
        guard let currentData = self.currentData else { return }
        var currentDetailData = [CurrentInfoDetailItem]()
        if let clouds = currentData.clouds?.all {
            currentDetailData.append(CurrentInfoDetailItem(emoji: "☁️", detailItem: String(clouds) + " %"))
        }
        if let rain = currentData.rain?.threeH {
            currentDetailData.append(CurrentInfoDetailItem(emoji: "💧", detailItem: String(rain) + " mm"))
        }
        if let snow = currentData.snow?.threeH {
            currentDetailData.append(CurrentInfoDetailItem(emoji: "❄️", detailItem: String(snow) + " mm"))
        }
        if let wind = currentData.wind.speed {
            let windKMH = Int(wind * 3.6)
            currentDetailData.append(CurrentInfoDetailItem(emoji: "💨", detailItem: String(windKMH) + " km/h"))
        }
        if let sunrise = currentData.sys?.sunrise {
            let time = removeDate(fromDate: Date(timeIntervalSince1970: Double(sunrise)))
            currentDetailData.append(CurrentInfoDetailItem(emoji: "🌅", detailItem: time.dateTimeToString()))
        }
        if let sunset = currentData.sys?.sunset {
            let time = removeDate(fromDate: Date(timeIntervalSince1970: Double(sunset)))
            currentDetailData.append(CurrentInfoDetailItem(emoji: "🌇", detailItem: time.dateTimeToString()))
        }
  
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

// MARK: UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfViewBeforeDragging = indexOfMajorView()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        scrollView.isUserInteractionEnabled = false
        
        let views = stackView.subviews
        let viewHeight = UIScreen.main.bounds.height
        
        // calculate where scrollView should snap to:
        let indexOfMajorView = self.indexOfMajorView()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.4
        let hasEnoughVelocityToSlideToTheNextView = indexOfViewBeforeDragging + 1 < views.count && velocity.y > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousView = indexOfViewBeforeDragging - 1 >= 0 && velocity.y < -swipeVelocityThreshold
        let majorViewIsTheViewBeforeDragging = indexOfMajorView == indexOfViewBeforeDragging
        let didUseSwipeToSkipView = majorViewIsTheViewBeforeDragging && (hasEnoughVelocityToSlideToTheNextView || hasEnoughVelocityToSlideToThePreviousView)
        
        if didUseSwipeToSkipView {
            let snapToIndex = indexOfViewBeforeDragging + (hasEnoughVelocityToSlideToTheNextView ? 1 : -1)
            let toValue = viewHeight * CGFloat(snapToIndex)

            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.y, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: 0, y: toValue)
                scrollView.layoutIfNeeded()
            }) { _ in
                scrollView.isUserInteractionEnabled = true
            }
            
        } else {
            scrollToView(index: indexOfMajorView)
        }
    }
    
    private func indexOfMajorView() -> Int {
        let viewHeight = UIScreen.main.bounds.height
        let proportionalOffset = scrollView.contentOffset.y / viewHeight
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(stackView.subviews.count - 1, index))
        return safeIndex
    }
    
    
    private func scrollToView(index: Int, velocity: Int = 0) {
        guard index >= 0 && index < stackView.subviews.count else { return }
        let offset: CGFloat = UIScreen.main.bounds.height * CGFloat(index)
        scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        scrollView.isUserInteractionEnabled = true
    }
}

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
        currentInfoView.delegate = self
        stackView.addArrangedSubview(currentInfoView)
        
        secondScreenView.translatesAutoresizingMaskIntoConstraints = false
        secondScreenView.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(secondScreenView)
    }
}

// MARK: CurrentInfoViewDelegate
extension MainViewController: CurrentInfoViewDelegate {
    func downChevronButtonWasTapped() {
        scrollToView(index: 1)
    }
}
