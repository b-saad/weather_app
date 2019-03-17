//
//  currentInfo.swift
//  Current Weather
//
//  Created by Bilal Saad on 2018-09-15.
//  Copyright © 2018 Bilal Saad. All rights reserved.
//

import Foundation

// Since the OpenWeatherAPI is odd, not really sure what we will get back, hence everything is an optional
struct CurrentWeather : Codable {
    let coord: coordinateInfo?
    let weather: [weatherInfo]
    let base: String?
    let main: mainInfo
    let visibility: Int?
    let wind: windInfo
    let rain: rainInfo?
    let snow: snowInfo?
    let clouds: cloudInfo?
    let dt: Int?
    let sys: sysInfo?
    let id: Int?
    let name: String?
    let cod: Int
}

struct coordinateInfo: Codable {
    let lon: Double?
    let lat: Double?
}

struct weatherInfo: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct mainInfo: Codable {
    let temp: Double?
    let pressure: Double?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    let seaLevel: Double?
    let grndLevel: Double?
    let tempKf: Double?
}

struct windInfo: Codable {
    let speed: Double?
    let deg: Double?
}
struct rainInfo: Codable {
//    let oneH: Double?
    let threeH: Double?
    
    enum CodingKeys: String, CodingKey {
//        case oneH = "1h"
        case threeH = "3h"
    }
}

struct cloudInfo: Codable{
    let all: Int?
}

struct snowInfo: Codable{
//    let oneH: Double?
    let threeH: Double?
    
    enum CodingKeys: String, CodingKey {
//        case oneH = "1h"
        case threeH = "3h"
    }
}

struct sysInfo: Codable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
