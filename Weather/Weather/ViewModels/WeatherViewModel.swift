//
//  File.swift
//  Weather
//
//  Created by Arun  Thakkar on 8/25/24.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weatherResponse: WeatherResponse?
    @Published var city: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let weatherService = WeatherService()
    // Change access level here
    let locationService = LocationService() // Changed from private to internal
   
    init() {
        // Load last city from UserDefaults if available
        if let lastCity = UserDefaults.standard.string(forKey: "lastCity") {
            self.city = lastCity
            fetchWeather(for: lastCity)
        }
        
        locationService.locationSubject
            .sink(receiveValue: { [weak self] location in
                self?.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            })
            .store(in: &cancellables)
        
        locationService.$authorizationStatus
            .filter { $0 == .authorizedWhenInUse }
            .compactMap { [weak self] _ in self?.locationService.location }
            .sink { [weak self] location in
                self?.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
            .store(in: &cancellables)
    }

    func fetchWeather(for city: String) {
        isLoading = true
        
        weatherService.fetchWeather(for: city)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { weatherResponse in
                self.weatherResponse = weatherResponse
                UserDefaults.standard.set(city, forKey: "lastCity")
            })
            .store(in: &cancellables)
    }
    
    func fetchWeather(lat: Double, lon: Double) {
        isLoading = true
        
        weatherService.fetchWeather(lat: lat, lon: lon)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { weatherResponse in
                self.weatherResponse = weatherResponse
                if let cityName = self.weatherResponse?.name {
                    UserDefaults.standard.set(cityName, forKey: "lastCity")
                }
            })
            .store(in: &cancellables)
    }
}
