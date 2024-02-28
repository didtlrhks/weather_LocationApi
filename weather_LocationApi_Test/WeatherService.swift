//
//  WeatherService.swift
//  weather_LocationApi_Test
//
//  Created by 양시관 on 2/28/24.
//

import Foundation
import SwiftUI
import CoreLocation

class WeatherService {
    func fetchWeather(latitude: Double, longitude: Double, apiKey: String, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=Seoul"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            } else {
                print("Failed to decode weather data")
                completion(nil)
            }
        }
        task.resume()
    }
}
