//
//  LocationManager.swift
//  weather_LocationApi_Test
//
//  Created by 양시관 on 3/7/24.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var location: CLLocationCoordinate2D?
    @Published var address: String = ""
    @Published var isLoading = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        isLoading = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func getAddress() {
        guard let location = self.lastLocation else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error)")
                self.isLoading = false
                return
            }
            if let placemark = placemarks?.first {
                self.address = [
                    placemark.administrativeArea,
                    placemark.locality,
                    placemark.subLocality,
                    placemark.thoroughfare,
                    placemark.subThoroughfare
                ].compactMap { $0 }.joined(separator: " ")
                print("Address: \(self.address)") // Print the full address
            }
            self.isLoading = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first
        location = lastLocation?.coordinate
        if let coordinate = location {
            print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)") // Print latitude and longitude
        }
        getAddress()
        isLoading = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
        isLoading = false
    }
}
