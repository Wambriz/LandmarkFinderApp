import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var initialLocationSet = false  // New flag to track the initial location update
    
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
    
    // CLLocationManagerDelegate Methods
    
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
            if !initialLocationSet {
                self.region.center = location
                initialLocationSet = true
            }
        }
    }
    
    func printCurrentLocation() {
        if let location = userLocation {
            print("Current Location: Latitude \(location.latitude), Longitude \(location.longitude)")
        } else {
            print("Current Location: Not available")
        }
    }
    
    func searchNearby(for query: String, completion: @escaping ([MKMapItem]) -> Void) {
            guard let userLocation = userLocation else {
                print("User location is not available")
                completion([])
                return
            }

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)

            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {
                    print("There was an error searching for: \(query) error: \(error?.localizedDescription ?? "Unknown error").")
                    completion([])
                    return
                }

                completion(response.mapItems)
            }
        }
    
    struct Landmark: Identifiable {
        var id = UUID()
        var name: String
        var location: CLLocationCoordinate2D
    }
}


