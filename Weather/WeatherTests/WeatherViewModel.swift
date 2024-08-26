//
//  WeatherViewModel.swift
//  WeatherTests
//
//  Created by Arun  Thakkar on 8/25/24.
//

import XCTest
import Combine
@testable import Weather

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = WeatherViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchWeather() {
        viewModel.city = "London"
        let expectation = self.expectation(description: "Weather data fetched successfully")

        viewModel.$weatherResponse
            .dropFirst()
            .sink(receiveValue: { weather in
                XCTAssertNotNil(weather)
                XCTAssertEqual(weather?.name, "London")
                XCTAssertNotNil(weather?.main.temp)
                XCTAssertNotNil(weather?.weather.first?.icon)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.fetchWeather(for: viewModel.city)

        waitForExpectations(timeout: 10, handler: nil)
    }
}

