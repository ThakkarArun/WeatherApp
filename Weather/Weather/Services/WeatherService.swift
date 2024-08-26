//
//  File.swift
//  Weather
//
//  Created by Arun  Thakkar on 8/25/24.
//

import Foundation
import Combine

class WeatherService {
    private let apiKey = "feb68e65d04e7e710db885412385da14"
    private let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let geocodingBaseURL = "https://api.openweathermap.org/data/2.5/geo/1.0/direct"
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(weatherBaseURL)?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(weatherBaseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

