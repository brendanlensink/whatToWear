//
//  Conditions.swift
//  whattowear
//
//  Created by Brendan Lensink on 2017-09-25.
//  Copyright © 2017 wsiw. All rights reserved.
//

import UIKit

enum Condition: String, Codable {
    case atmosphere = "Atmosphere"
    case clear = "Clear"
    case clouds = "Clouds" // todo: should be cloudy. need title var ithink
    case drizzle = "Drizzle"
    case extreme = "Extreme"
    case rain = "Rain"
    case snow = "Snow"
    case thunderstorm = "Thunderstorm"

    var image: UIImage? {
        switch self {
        case .clouds: return #imageLiteral(resourceName: "cloud")
        case .rain: return #imageLiteral(resourceName: "cloudrain")
        case .snow: return #imageLiteral(resourceName: "cloudsnow")
        case .thunderstorm: return #imageLiteral(resourceName: "cloudthunder")
        case .clear: return #imageLiteral(resourceName: "sun")
        default: return nil
        }
    }
}
