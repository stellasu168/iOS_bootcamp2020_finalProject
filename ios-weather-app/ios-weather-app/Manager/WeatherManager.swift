//
//  WeatherManager.swift
//  ios-weather-app
//
//  Created by Stella Su on 8/6/20.
//  Copyright © 2020 Stella Su. All rights reserved.
//

import Foundation
import Alamofire

struct WeatherManager {
    
    private let API_Key = "0298d254977db08da0e4235109243777"
    
    // Use completion handler to return the data
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void){
        
        // Encoding because if user type in a space or whatever, you can handle it
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let urlString = String(format: path, query, API_Key)
        
        AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let weatherData):
                print("weatherData: \(weatherData)")
                let model = weatherData.model
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
}
