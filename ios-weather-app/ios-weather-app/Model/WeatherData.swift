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
    
    // A computed property
    var model: WeatherModel {
        return WeatherModel(cityName: name, temp: main.temp.toInt(), conditionId: weather.first?.id ?? 0, conditionDescription:  weather.first?.description ?? "")
    }
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}

// A view model - convert from the WeatherData struct so it's easier to access
struct WeatherModel {
    
    let cityName: String
    let temp: Int
    let conditionId: Int
    let conditionDescription: String
    
    var conditionImage: String {
        switch conditionId {
        case 200...299:
            return "imThunderstorm"
        case 300...399:
            return "imDrizzle"
        case 500...599:
            return "imRain"
        case 600...699:
                return "imSnow"
        case 700...799:
                return "imAtmosphere"
        case 800:
            return "imClear"
        default:
            return "imClouds"
        }
    }
}
