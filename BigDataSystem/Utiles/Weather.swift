//
//  Weather.swift
//  BigDataSystem
//
//  Created by a mystic on 4/30/24.
//

import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let main: String
}
