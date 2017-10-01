//
//  WeatherResponse.swift
//  whattowear
//
//  Created by Brendan Lensink on 2017-09-24.
//  Copyright © 2017 wsiw. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]

    struct Main: Codable {
        let temp: Double
    }

    struct Weather: Codable {
        let description: String
        let main: Condition
    }
}
