//
//  ViewController.swift
//  ios-weather-app
//
//  Created by Stella Su on 7/30/20.
//  Copyright © 2020 Stella Su. All rights reserved.
//

import UIKit
import SkeletonView

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        fetchWeather()
    }
    
    private func fetchWeather(){
        weatherManager.fetchWeather(byCity: "San Jose") { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let weatherData):
                this.updateView(with: weatherData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateView(with data: WeatherData) {
        hideAnimation()
        temperatureLabel.text = data.main.temp.toString().appending("°C")
        conditionLabel.text = data.weather.first?.description
        navigationItem.title = data.name

    }
    
    private func showAnimation(){
        conditionImageView.showAnimatedGradientSkeleton()
        temperatureLabel.showAnimatedGradientSkeleton()
        conditionLabel.showAnimatedGradientSkeleton()
    }
    
    private func hideAnimation(){
        conditionImageView.hideSkeleton()
        temperatureLabel.hideSkeleton()
        conditionLabel.hideSkeleton()
    }

    @IBAction func addLocationButtonTapped(_ sender: Any) {
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
    }
    
}

