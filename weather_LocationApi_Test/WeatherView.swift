//
//  WeatherView.swift
//  weather_LocationApi_Test
//
//  Created by 양시관 on 2/28/24.
//

import Foundation
import SwiftUI
struct WeatherView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?

    var body: some View {
        VStack {
            if let weatherData = weatherData {
                Text("Temperature: \(weatherData.temperature)°C")
                Text("Condition: \(weatherData.condition)")
            } else {
                Text("Fetching weather data...")
            }
        }
        .onAppear {
            guard let location = locationManager.location else { return }
            WeatherService().fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, apiKey: "YOUR_API_KEY_HERE") { data in
                self.weatherData = data
            }
        }
    }
}
