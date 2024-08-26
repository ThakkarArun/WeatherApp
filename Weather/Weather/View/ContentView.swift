//
//  ContentView.swift
//  Weather
//
//  Created by Arun  Thakkar on 8/25/24.
//

import SwiftUI
import Combine
import CoreLocation


struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let weather = viewModel.weatherResponse {
                    VStack {
                        HStack {
                            TextField("Enter city", text: $viewModel.city, onCommit: {
                                viewModel.fetchWeather(for: viewModel.city)
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            
                            Button(action: {
                                viewModel.fetchWeather(for: viewModel.city)
                            }) {
                                Text("Search")
                                    .padding(8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        if let icon = weather.weather.first?.icon {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        }
                    }
                    .padding()
                    List(){
                        Text("City: \(weather.name)")
                        Text("Temperature: \(weather.main.temp)°C")
                        Text("Humidity: \(weather.main.humidity)%")
                        Text("Description: \(weather.weather.first?.description ?? "N/A")")
                    }
                
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Weather App")
            .onAppear {
                // Fetch weather for last city if available
                if let lastCity = UserDefaults.standard.string(forKey: "lastCity") {
                    viewModel.fetchWeather(for: lastCity)
                }
                
                // Request location authorization
                if viewModel.locationService.authorizationStatus == .notDetermined {
                    viewModel.locationService.locationManager.requestWhenInUseAuthorization()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

