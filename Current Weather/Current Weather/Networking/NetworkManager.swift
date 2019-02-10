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
    func retrieveCurrentWeatherInfo(from endPoint: CurrentInfoEndPoint, completion: @escaping (_ currentInfo: CurrentInfo) -> Void)
}

extension NetworkManagerProtocol {
    func retrieveCurrentWeatherInfo(from endPoint: CurrentInfoEndPoint, completion: @escaping (_ currentInfo: CurrentInfo) -> Void){
        guard let url = endPoint.url else {
            print("URL is nil")
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("no data")
                return
            }
            guard let currentInfo = try? decoder.decode(CurrentInfo.self, from: data) else {
                print ("Error: Could not decode data into main")
                return
            }
            completion(currentInfo)
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

struct CurrentInfoEndPoint: APIEndPoint {
    private let baseUrlString: String = "http://api.openweathermap.org"
    private let path: String = "/data/2.5/weather?"
    private let latitude: Double
    private let longitude: Double
    private let units: TemperatureUnits
    private let apiKey: String = "339a7e971419e55d3f22bb1aa8ce23f3"
    private var queries: [String] = []
    var url: URL? = nil
    
    init(latitude: Double, longitude: Double, units: TemperatureUnits = .celsius) {
        self.latitude = latitude
        self.longitude = longitude
        self.units = units
        url = buildUrlWithCoordinates()
    }
    
    private func buildQueryParameterString(parameter: String, value: String) -> String {
        return parameter + "=" + value
    }
    
    private mutating func buildQueries() {
        let latitudeQuery = buildQueryParameterString(parameter: openWeatherApiQueryParameters.latitude.rawValue, value: String(latitude))
        let longitudeQuery = buildQueryParameterString(parameter: openWeatherApiQueryParameters.longtitude.rawValue, value: String(longitude))
        let unitsQuery = buildQueryParameterString(parameter: openWeatherApiQueryParameters.units.rawValue, value: units.rawValue)
        let apiIdQuery = buildQueryParameterString(parameter: openWeatherApiQueryParameters.apiKey.rawValue, value: apiKey)
        queries.append(latitudeQuery)
        queries.append(longitudeQuery)
        queries.append(unitsQuery)
        queries.append(apiIdQuery)
    }
    
    private mutating func buildUrlWithCoordinates() -> URL? {
        buildQueries()
        var finalUrlString = baseUrlString + path
        for query in queries {
            finalUrlString += query + "&"
        }
        finalUrlString.removeLast()
        return URL(string: finalUrlString) ?? nil
    }
    
}
