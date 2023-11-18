import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    //CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.authorizationStatus = status
            self.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.authorizationStatus = status
            self.userLocation = nil
        default:
            self.authorizationStatus = .notDetermined
            self.userLocation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            self.userLocation = location
            self.region.center = location
        }
    }
    
    func printCurrentLocation() {
            if let location = userLocation {
                print("Current Location: Latitude \(location.latitude), Longitude \(location.longitude)")
            } else {
                print("Current Location: Not available")
            }
        }
}

