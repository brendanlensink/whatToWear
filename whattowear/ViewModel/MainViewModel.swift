//
//  MainViewModel.swift
//  whattowear
//
//  Created by Brendan Lensink on 2017-09-23.
//  Copyright © 2017 wsiw. All rights reserved.
//

import Alamofire
import MapKit
import ReactiveSwift
import ReactiveAlamofire
import Result
import UIKit

class MainViewModel {
    private let date = Date()
    private let calendar = Calendar.current
    private let formatter = DateFormatter()

    private let locationManager = CLLocationManager()
    private let apiKey = "e2671a526b61c906f2c74af9b63ac9e8"

    // MARK: Reactive Elements

    let (responseSignal, responseObserver) = Signal<WeatherResponse, NoError>.pipe()
    let (errorSignal, errorObserver) = Signal<String, NoError>.pipe()

    // MARK: Lifecycle

    init() {
        formatter.dateFormat = "EEEE, MMMM d"

        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse, let currentLocation = locationManager.location {
            SignalProducer<DataRequest, NoError> {
                return .success(Alamofire.request("https://api.openweathermap.org/data/2.5/weather?APPID=\(self.apiKey)&lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)"))
                }
                .responseProducer()
                .parseResponse(DataRequest.dataResponseSerializer())
                .startWithResult { result in
                    switch result {
                    case .failure(let error):
                        self.errorObserver.send(value: error.description)
                    case .success(let resp):
                        let decoder = JSONDecoder()
                        let weather = try! decoder.decode(WeatherResponse.self, from: resp.result.value!)
                        self.responseObserver.send(value: weather)
                    }
            }
        }
    }

    func getTitleText() -> String {
        return "Good \(getTimeSlice()) Brynn!"
    }

    func getHeaderText(forWeather weatherResponse: WeatherResponse) -> String {
        let temperature = weatherResponse.main.temp.toRoundedC()

        var returnString = "It's \(getFormattedDate()) and \n it's going to be \(temperature)\u{00B0}C"

        if let weather = weatherResponse.weather.first {
            returnString += " and \(weather.main.rawValue.lowercased())"
        }

        returnString += " today."

        return returnString
    }

    func getImage(forWeather weatherResponse: WeatherResponse) -> UIImage {
        return getWear(forWeather: weatherResponse).image
    }

    func getWeatherImage(forWeather weatherResponse: WeatherResponse) -> UIImage? {
        guard let weather = weatherResponse.weather.first else {
            // TODO: handle this better
            fatalError("Failed to unwrap weather")
        }

        switch weather.main {
        case .clear: return #imageLiteral(resourceName: "sun")
        case .clouds: return #imageLiteral(resourceName: "cloud")
        case .drizzle, .rain: return #imageLiteral(resourceName: "cloudrain")
        case .thunderstorm: return #imageLiteral(resourceName: "cloudthunder")
        case .snow: return #imageLiteral(resourceName: "cloudsnow")
        default: return nil
        }
    }

    func getFooterText(forWeather weatherResponse: WeatherResponse) -> String {

        // decide what clothing to weather
        return "You should wear \(getWear(forWeather: weatherResponse))"
    }

    // MARK: Private Helpers

    private func getTimeSlice() -> String {
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 5,6,7,8,9,10,11:
            return "morning"
        case 12,13,14,15,16:
            return "afternoon"
        case 17,18,19,20,21,22,23:
            return "evening"
        default:
            return "day"
        }
    }

    private func getFormattedDate() -> String {
        var dateString = formatter.string(from: date)

        switch dateString.last! {
        case "1":
            dateString.append("st")
        case "2":
            dateString.append("nd")
        case "3":
            dateString.append("rd")
        default:
            dateString.append("th")
        }
        return dateString
    }

    private func getWear(forWeather weatherResponse: WeatherResponse) -> Wear {
        guard let weather = weatherResponse.weather.first else {
            // TODO: handle this better
            fatalError("Failed to unwrap weather")
        }

        // first check for easter egg dates
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)

        switch (day, month) {
        case (18, 11): return Wear.birthdaySuit
        case (25, 12): return Wear.santaHat
        case (31, 10): return Wear.sweetCostume
        default: break
        }

        // otherwise, figure out the current temp and weather and decide from there

        let temperature = weatherResponse.main.temp.toRoundedC()

        switch temperature {
        case ..<(-5):
            switch weather.main {
            default: return Wear.parka
            }
        case -5..<10:
            switch weather.main {
            case .rain: return Wear.parka
            default: return Wear.sweater
            }
        case 10..<20:
            switch weather.main {
            case .rain: return Wear.umbrella
            case .drizzle: return Wear.umbrella
            default: return Wear.shorts
            }
        case 20..<30:
            switch weather.main {
            case .clouds: return Wear.shorts
            default: return Wear.sunglasses
            }
        default: return Wear.inside
        }
    }
}
