//
//  currentInfo.swift
//  Current Weather
//
//  Created by Bilal Saad on 2018-09-15.
//  Copyright © 2018 Bilal Saad. All rights reserved.
//

import Foundation

// Since the OpenWeatherAPI is odd, not really sure what we will get back, hence everything is an optional
struct CurrentInfo : Codable {
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
    let lon: Float?
    let lat: Float?
}

struct weatherInfo: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct mainInfo: Codable {
    let temp: Float?
    let pressure: Float?
    let humidity: Int?
    let tempMin: Float?
    let tempMax: Float?
    let seaLevel: Float?
    let grndLevel: Float?
}

struct windInfo: Codable {
    let speed: Float?
    let deg: Float?
}
struct rainInfo: Codable {
    let oneH: Float?
    let threeH: Float?
    
    enum CodingKeys: String, CodingKey {
        case oneH = "1h"
        case threeH = "3h"
    }
}

struct cloudInfo: Codable{
    let all: Int?
}

struct snowInfo: Codable{
    let oneH: Float?
    let threeH: Float?
    
    enum CodingKeys: String, CodingKey {
        case oneH = "1h"
        case threeH = "3h"
    }
}

struct sysInfo: Codable {
    let type: Int?
    let id: Int?
    let message: Float?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
