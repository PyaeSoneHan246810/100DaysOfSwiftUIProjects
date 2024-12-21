//
//  LocationManager.swift
//  EventContacts
//
//  Created by Dylan on 20/12/2024.
//

import Foundation
import CoreLocation
import MapKit
import Observation

enum LocationError: LocalizedError {
    case authorizationDenied
    case authorizationRestricted
    case unknownLocation
    case accessDenied
    case networkFailed
    case operationFailed
    
    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return NSLocalizedString("Location access denied.", comment: "")
        case .authorizationRestricted:
            return NSLocalizedString("Location access restricted.", comment: "")
        case .unknownLocation:
            return NSLocalizedString("Unknown location.", comment: "")
        case .accessDenied:
            return NSLocalizedString("Access denied.", comment: "")
        case .networkFailed:
            return NSLocalizedString("Network failed.", comment: "")
        case .operationFailed:
            return NSLocalizedString("Operation failed.", comment: "")
        }
    }
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared: LocationManager = LocationManager()
    
    let clLocationManager: CLLocationManager = CLLocationManager()
    
    var lastKnownLocation: CLLocationCoordinate2D?
    var error: LocationError?
    
    private override init() {
        super.init()
        clLocationManager.delegate = self
    }
}

extension LocationManager {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied:
            error = .authorizationDenied
        case .restricted:
            error = .authorizationRestricted
        @unknown default:
            error = .operationFailed
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last?.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                self.error = .unknownLocation
            case .denied:
                self.error = .accessDenied
            case .network:
                self.error = .networkFailed
            default:
                self.error = .operationFailed
            }
        }
    }
}
