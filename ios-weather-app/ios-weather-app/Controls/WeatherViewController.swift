//
//  WeatherViewController.swift
//  ios-weather-app
//
//  Created by Stella Su on 7/30/20.
//  Copyright © 2020 Stella Su. All rights reserved.
//

import UIKit
import SkeletonView
import CoreLocation

protocol WeatherViewControllerDelegate: class {
    func didUpdateWeatherFromSearch(model: WeatherModel)
}

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    // Use lazy var bc locationManager is not being initilized imediately after app loading
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        // self is the WeatherViewController
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeather(byCity: "Berlin")
    }
    
    private func fetchWeather(byLocation location: CLLocation){
        showAnimation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeather(lat: lat, lon: lon) { [weak self](result) in
            guard let this = self else { return }
            this.handleResult(result)
        }
    }
    
    private func fetchWeather(byCity city: String){
        showAnimation()
        weatherManager.fetchWeather(byCity: city) { [weak self] (result) in
            guard let this = self else { return }
            this.handleResult(result)

        }
    }
    
    private func handleResult(_ result: Result<WeatherModel, Error>){
        switch result {
        case .success(let model):
            updateView(with: model)
        case .failure(let error):
            print(error)
        }
    }
    
    private func updateView(with model: WeatherModel) {
        hideAnimation()
        temperatureLabel.text = model.temp.toString().appending("°C")
        conditionLabel.text = model.conditionDescription
        navigationItem.title = model.cityName
        conditionImageView.image = UIImage(named: model.conditionImage)

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
        performSegue(withIdentifier: "showAddCity", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddCity" {
            if let destination = segue.destination as? AddCityViewController {
                destination.delegate = self
            }
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        default:
            promptForLocationPermission()
        }
    }
    
    private func promptForLocationPermission() {
        let alertController = UIAlertController(title: "Requires Location Permission", message: "Would you like to enable location permission in Settings?", preferredStyle: .alert)
        let enableAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(enableAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
} // End of the WeatherViewController class

// Implement the protocol here
extension WeatherViewController: WeatherViewControllerDelegate {
    func didUpdateWeatherFromSearch(model: WeatherModel) {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let this = self else { return }
            this.updateView(with: model)
        })
    }
}

// Implement the delegate here:
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last{
            manager.stopUpdatingLocation()
            fetchWeather(byLocation: location)
//            let lat = location.coordinate.latitude
//            let long = location.coordinate.longitude
//            print(lat, long)
//
//            weatherManager.fetchWeather(lat: lat, lon: long) { (result) in
//                switch result {
//                case .success(let model):
//                    // We want to move this thread to the main thread since this is happening in the background
//                    DispatchQueue.main.async {
//                        self.updateView(with: model)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
