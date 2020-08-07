//
//  Double+Extensions.swift
//  ios-weather-app
//
//  Created by Stella Su on 8/6/20.
//  Copyright © 2020 Stella Su. All rights reserved.
//

import Foundation

extension Double {
    func toString() ->String{
        return String(format: "%.1f", self)
    }
}
