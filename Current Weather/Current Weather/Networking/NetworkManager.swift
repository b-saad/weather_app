//
//  NetworkManager.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-02-07.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    var session: URLSession { get }
    func retrieveCurrentWeatherInfo(from endPoint: CurrentWeatherEndPoint, completion: @escaping (_ currentInfo: CurrentWeather) -> Void)
}

extension NetworkManagerProtocol {
    func retrieveCurrentWeatherInfo(from endPoint: CurrentWeatherEndPoint, completion: @escaping (_ currentInfo: CurrentWeather) -> Void){
        guard let url = endPoint.url else {
            print("URL is nil")
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("no current weather data")
                return
            }
            guard let currentWeatherInfo = try? decoder.decode(CurrentWeather.self, from: data) else {
                print ("Error: Could not decode data into CurrentWeatherModel")
                print ("Response: \(data)")
                return
            }
            completion(currentWeatherInfo)
        }
        task.resume()
    }
    
    func retrieveFiveDayForecastInfo(from endPoint: FiveDayForecastEndpoint, completion: @escaping (_ fiveDayForecast: FiveDayForecast) -> Void){
        guard let url = endPoint.url else {
            print("URL is nil")
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("no 5 day forcast data")
                return
            }
            guard let fiveDayForecastInfo = try? decoder.decode(FiveDayForecast.self, from: data) else {
                print ("Error: Could not decode data into FiveDayForecastModel")
                print ("Response: \(response)")
                return
            }
            completion(fiveDayForecastInfo)
        }
        task.resume()
    }
}

class NetworkManager: NetworkManagerProtocol {
    let session: URLSession = .shared
    static let shared: NetworkManagerProtocol = NetworkManager()
}

protocol APIEndPoint {
    var url: URL? { get set }
}




