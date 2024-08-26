//
//  WeatherServiceTests.swift
//  WeatherTests
//
//  Created by Arun  Thakkar on 8/25/24.
//

import XCTest
import Combine

@testable import Weather

class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        weatherService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        let expectation = self.expectation(description: "Weather data fetched successfully")

        weatherService.fetchWeather(for: "London")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected successful fetch, but received error: \(error)")
                }
            }, receiveValue: { weatherResponse in
                XCTAssertEqual(weatherResponse.name, "London")
                XCTAssertNotNil(weatherResponse.main.temp)
                XCTAssertNotNil(weatherResponse.weather.first?.icon)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchWeatherFailure() {
        let expectation = self.expectation(description: "Weather data fetch failure")

        weatherService.fetchWeather(for: "InvalidCityName")
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { weatherResponse in
                XCTFail("Expected failure, but received weather data: \(weatherResponse)")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 10, handler: nil)
    }
}

