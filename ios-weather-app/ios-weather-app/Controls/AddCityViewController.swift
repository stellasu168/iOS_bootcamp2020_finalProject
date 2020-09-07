//
//  AddCityViewController.swift
//  ios-weather-app
//
//  Created by Stella Su on 8/8/20.
//  Copyright © 2020 Stella Su. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    
    weak var delegate: WeatherViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // control is currently ready to respond to actions
        cityTextField.becomeFirstResponder()//bring up the keyboard
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        statusLabel.isHidden = true
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        statusLabel.isHidden = true
        guard let query = cityTextField.text, !query.isEmpty else {
            showSearchError(text: "City cannot be empty. Please try again!")
            return }
        handleSearch(query: query)
    }
    
    private func handleSearch(query: String) {
        view.endEditing(true)
        activityIndicatorView.startAnimating()
        // Add weak self to avoid a renten cycle
        weatherManager.fetchWeather(byCity: query) { [weak self] (result) in
            guard let this = self else { return }
            this.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let model):
                print(model)
                this.handleSearchSuccess(model: model)
            case .failure(let error):
                this.showSearchError(text: error.localizedDescription)
            }
        }
    }
    
    private func handleSearchSuccess(model: WeatherModel) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemGreen
        statusLabel.text = "Success!"
        // How do we tell who owns the delegate?
        // We passed 'self' in the prepare for segue function
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            self?.delegate?.didUpdateWeatherFromSearch(model: model)
        }
    }
    
    private func showSearchError(text: String) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemRed
        statusLabel.text = text
    }
    
}

extension AddCityViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
