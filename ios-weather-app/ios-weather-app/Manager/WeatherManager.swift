//
//  WeatherManager.swift
//  ios-weather-app
//
//  Created by Stella Su on 8/6/20.
//  Copyright © 2020 Stella Su. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherError: Error, LocalizedError {
    case unknown
    case invalidCity
    case custom(description: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCity:
            return "This is an invalid city. Please try again"
        case .unknown:
            return "Hey, this is an unknown error!"
        case .custom(description: let description):
            return description
        }
    }
}

struct WeatherManager {
    private let API_Key = "0298d254977db08da0e4235109243777"
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
            
            // Encoding because if user type in a space or whatever, you can handle it
            // api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={your api key}
            let path = "https://api.openweathermap.org/data/2.5/weather?appid=%@&units=metric&lat=%f&lon=%f"
            let urlString = String(format: path, API_Key, lat, lon)
            
            handleRequest(urlString: urlString, completion: completion)

//            AF.request(urlString)
//                .validate()
//                .responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
//                switch response.result {
//                case .success(let weatherData):
//                    print("weatherData: \(weatherData)")
//                    let model = weatherData.model
//                    completion(.success(model))
//                case .failure(let error):
//                    if let err = self.getWeatherError(error: error, data: response.data) {
//                        completion(.failure(err))
//                    } else {
//                        completion(.failure(error))
//                    }
//                }
//            }
        }
    
    // Use completion handler to return the data
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {

        // Encoding because if user type in a space or whatever, you can handle it
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let urlString = String(format: path, query, API_Key)

        handleRequest(urlString: urlString, completion: completion)
        
//        AF.request(urlString)
//            .validate()
//            .responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
//            switch response.result {
//            case .success(let weatherData):
//                print("weatherData: \(weatherData)")
//                let model = weatherData.model
//                completion(.success(model))
//            case .failure(let error):
//                if let err = self.getWeatherError(error: error, data: response.data) {
//                    completion(.failure(err))
//                } else {
//                    completion(.failure(error))
//                }
////                if error.responseCode == 404 {
////                    let invalidCityError = WeatherError.custom(description: "this is random")
////                    completion(.failure(invalidCityError))
////                } else {
////                    completion(.failure(error))
////                }
//            }
//        }
    }
    
    private func handleRequest(urlString: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        AF.request(urlString)
             .validate()
             .responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
             switch response.result {
             case .success(let weatherData):
                 print("weatherData: \(weatherData)")
                 let model = weatherData.model
                 completion(.success(model))
             case .failure(let error):
                 if let err = self.getWeatherError(error: error, data: response.data) {
                     completion(.failure(err))
                 } else {
                     completion(.failure(error))
                 }
             }
         }
    }
    private func getWeatherError(error: AFError, data: Data?) -> Error? {
        if error.responseCode == 404,
            let data = data,
            let failure = try? JSONDecoder().decode(WeatherDataFailure.self, from: data) {
            let message = failure.message
            return WeatherError.custom(description: message)
        } else {
            return nil
        }
    }
    
}
