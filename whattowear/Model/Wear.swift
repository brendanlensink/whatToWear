//
//  Wear.swift
//  whattowear
//
//  Created by Brendan Lensink on 2017-09-25.
//  Copyright © 2017 wsiw. All rights reserved.
//

import UIKit

enum Wear: String {
    case hat
    case parka
    case shorts
    case sunglasses
    case sweater
    case umbrella
    case inside = "stay inside"

    // MARK: joke values

    case birthdaySuit = "birthday suit"
    case santaHat = "santa hat"
    case sweetCostume = "sweet costume"

    var image: UIImage {
        switch self {
        case .hat: return #imageLiteral(resourceName: "hat")
        case .parka: return #imageLiteral(resourceName: "parka")
        case .shorts: return #imageLiteral(resourceName: "shorts")
        case .sunglasses: return #imageLiteral(resourceName: "sunglasses")
        case .sweater: return #imageLiteral(resourceName: "sweater")
        case .umbrella: return #imageLiteral(resourceName: "umbrella")
        default: return #imageLiteral(resourceName: "sweaterPlaceholder")
        }
    }
}
