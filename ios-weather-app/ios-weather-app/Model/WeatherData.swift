//
//  WeatherData.swift
//  ios-weather-app
//
//  Created by Stella Su on 8/6/20.
//  Copyright © 2020 Stella Su. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}
