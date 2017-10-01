//
//  Double+ToTemperature.swift
//  whattowear
//
//  Created by Brendan Lensink on 2017-09-25.
//  Copyright © 2017 wsiw. All rights reserved.
//

import Foundation

extension Double {
    func toRoundedC() -> Int {
        return Int((self - 273.15).rounded())
    }
}
