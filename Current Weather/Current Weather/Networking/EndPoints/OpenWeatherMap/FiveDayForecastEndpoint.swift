//
//  File.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-03-16.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import Foundation

class FiveDayForecastEndpoint: openWeatherApiEndpoint {
    override init(latitude: Double, longitude: Double, units: TemperatureUnits = .celsius, path: String) {
        super.init(latitude: latitude, longitude: longitude, units: units, path: path)
    }
    
    convenience init(latitude: Double, longitude: Double, units: TemperatureUnits = .celsius ) {
        self.init(latitude: latitude, longitude: longitude, units: units, path: "/data/2.5/forecast")
    }
}
