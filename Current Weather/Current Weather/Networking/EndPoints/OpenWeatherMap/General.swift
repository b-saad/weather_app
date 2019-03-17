//
//  General.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-03-16.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import Foundation

enum TemperatureUnits: String {
    case celsius = "metric"
    case fahrenheit = "imperial"
}

enum openWeatherApiQueryParameters: String {
    case latitude = "lat"
    case longtitude = "lon"
    case units = "units"
    case apiKey = "APPID"
}

class openWeatherApiEndpoint: APIEndPoint {
    private let latitude: Double
    private let longitude: Double
    private let units: TemperatureUnits
    private let apiKey: String = "339a7e971419e55d3f22bb1aa8ce23f3"
    private var urlComponent: URLComponents? = nil
    var path: String = ""
    var url: URL? = nil
    
    init(latitude: Double, longitude: Double, units: TemperatureUnits = .celsius, path: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.units = units
        self.path = path
        urlComponent = buildUrlWithCoordinates()
        url = urlComponent?.url
    }
    
    private func buildUrlWithCoordinates() -> URLComponents {
        var urlComponent: URLComponents = URLComponents.init()
        urlComponent.scheme = "http"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = path
        urlComponent.queryItems = [
            URLQueryItem.init(name: openWeatherApiQueryParameters.latitude.rawValue, value: String(latitude)),
            URLQueryItem.init(name: openWeatherApiQueryParameters.longtitude.rawValue,  value: String(longitude)),
            URLQueryItem.init(name: openWeatherApiQueryParameters.units.rawValue, value:units.rawValue),
            URLQueryItem.init(name: openWeatherApiQueryParameters.apiKey.rawValue, value: apiKey)
        ]
        return urlComponent
    }
}
