//
//  WeatherManager.swift
//  weather_LocationApi_Test
//
//  Created by 양시관 on 3/7/24.
//

import Foundation
import CoreLocation

class WeatherManager {
    // HTTP request to get the current weather depending on the coordinates we got from LocationManager
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        // Replace YOUR_API_KEY in the link below with your own
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=040a03e00601edb517a2b4ba4ce5550d&units=metric") else { fatalError("Missing URL") }
     
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        fetchWeather(latitude: latitude, longitude: longitude)
        
        return decodedData
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)/* async throws -> ResponseBody*/ {
        let weatherManager = WeatherManager()
//        let latitude: CLLocationDegrees = 37.7749 // Example latitude
//        let longitude: CLLocationDegrees = -122.4194 // Example longitude
        
        Task {
            do {
                let weather = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
                print("________________________________________________________________________________")
                print("Current weather in \(weather.name): \(weather.weather.first?.main ?? "Unknown") - \(weather.weather.first?.description ?? "No description")")
                print("Temperature: \(weather.main.temp)°C, Feels like: \(weather.main.feels_like)°C")
                print("Min temperature: \(weather.main.temp_min)°C, Max temperature: \(weather.main.temp_max)°C")
                print("Wind Speed: \(weather.wind.speed)m/s, Direction: \(weather.wind.deg) degrees")
                print("________________________________________________________________________________")
            } catch {
                print("Failed to fetch weather data: \(error)")
            }
        }
        
      
    }
    
    
}

// Model of the response body we get from calling the OpenWeather API
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}

