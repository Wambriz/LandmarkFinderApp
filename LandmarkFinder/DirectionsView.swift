import SwiftUI
import MapKit

struct DirectionsView: View {
    @StateObject private var landmarkVM = LandmarkViewModel()
    var startCoordinate: CLLocationCoordinate2D
    var endCoordinate: CLLocationCoordinate2D
    
    @State private var region: MKCoordinateRegion
    @State private var route: MKRoute?
    @State private var isFavorited = false
    
    var currentLandmark: Landmark
    
    @State private var showAlert = false
    
    init(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D, currentLandmark: Landmark) {
        self.startCoordinate = startCoordinate
        self.endCoordinate = endCoordinate
        self.currentLandmark = currentLandmark
        self._region = State(initialValue: MKCoordinateRegion(
            center: startCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [startCoordinate, endCoordinate]) { location in
                MapPin(coordinate: location, tint: .red)
            }
            .overlay(
                RouteView(route: $route)
            )
            .edgesIgnoringSafeArea([.horizontal, .bottom])

            Spacer()

            Button(action: {
                isFavorited.toggle()
                if isFavorited {
                    landmarkVM.addFavoriteLandmark(landmark: currentLandmark)
                    showAlert = true  // Show alert when favorited
                } else {
                    landmarkVM.removeFavoriteLandmark(landmarkId: currentLandmark.id)
                }
            }) {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .resizable()  // Make the heart icon resizable
                    .frame(width: 40, height: 40)  // Set a larger size for the icon
                    .foregroundColor(isFavorited ? .red : .gray)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Saved"), message: Text("Landmark has been saved to favorites."))
            }
        }
        .onAppear {
            calculateRoute()
        }
        .navigationBarTitle(currentLandmark.name, displayMode: .inline)
    }

    
    
    
    private func calculateRoute() {
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: endPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.route = route
                self.region = MKCoordinateRegion(route.polyline.boundingMapRect)
            }
        }
    }
}

struct RouteView: UIViewRepresentable {
    @Binding var route: MKRoute?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let route = route {
            uiView.addOverlay(route.polyline)
            uiView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        }
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeOverlays(uiView.overlays)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RouteView
        
        init(_ parent: RouteView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude),\(longitude)"
    }
}




