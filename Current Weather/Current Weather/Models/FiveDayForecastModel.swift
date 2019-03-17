//
//  FiveDayForecastModl.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-03-16.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import Foundation

struct FiveDayForecast: Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [List?]
    let city: City?
}

struct List: Codable {
    let dt: Double?
    let main: mainInfo?
    let weather: [weatherInfo?]
    let clouds: cloudInfo?
    let wind: windInfo?
    let rain: rainInfo?
    let snow: snowInfo?
    let sys: Sys?
    let dtTxt: String?
}

struct City: Codable {
    let id: Double?
    let name: String?
    let coord: coordinateInfo?
    let country: String?
    let population: Double?
}

struct Sys: Codable {
    let pod: String?
}
