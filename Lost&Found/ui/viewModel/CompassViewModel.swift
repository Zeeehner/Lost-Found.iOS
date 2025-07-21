//
//  CompassViewModel.swift
//  Lost&Found
//
//  Created by Noah on 21.07.25.
//

class CompassViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var heading: Double = 0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        }
    }
    
    func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Kein Zugriff auf Standort erlaubt. Kompass funktioniert nicht.")
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.headingAvailable() {
                locationManager.startUpdatingHeading()
            }
        @unknown default:
            break
        }
    }
}
