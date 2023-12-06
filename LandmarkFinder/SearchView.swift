import SwiftUI
import MapKit

// Wrapper for MKMapItem to Identifiable
struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var locationManager = LocationManager()
    @State private var searchResults = [IdentifiableMapItem]()
    @State private var selectedPlace: IdentifiableMapItem?
    @State private var isNavigatingToDirections = false
    @State private var destinationCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            TextField("Search landmarks", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                .onChange(of: searchText) { newValue in
                    performSearch(query: newValue)
                }
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    List(searchResults, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.mapItem.name ?? "Unknown")
                                Text(item.mapItem.placemark.title ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            NavigationLink(destination: DirectionsView(
                                startCoordinate: locationManager.userLocation ?? CLLocationCoordinate2D(),
                                endCoordinate: item.mapItem.placemark.coordinate,
                                currentLandmark: mapItemToLandmark(mapItem: item.mapItem)
                            ), isActive: $isNavigatingToDirections) {
                                EmptyView()
                            }
                            .hidden()
                            
                            Button("Directions") {
                                destinationCoordinate = item.mapItem.placemark.coordinate
                                isNavigatingToDirections = true
                            }
                            .buttonStyle(.bordered)
                        }
                        .onTapGesture {
                            centerMapOnLocation(location: item.mapItem.placemark.coordinate)
                        }
                    }
                    .frame(height: geometry.size.height / 2)
                    
                    Map(coordinateRegion: $locationManager.region,
                        annotationItems: selectedPlace != nil ? [selectedPlace!] : []) { place in
                        MapPin(coordinate: place.mapItem.placemark.coordinate)
                    }
                        .frame(height: geometry.size.height / 1.81)
                }
            }
        }
        .navigationBarTitle("Search Landmarks", displayMode: .inline)
    }
    
    private func performSearch(query: String) {
        locationManager.searchNearby(for: query) { results in
            self.searchResults = results.map { IdentifiableMapItem(mapItem: $0) }
            self.selectedPlace = nil
        }
    }
    
    private func centerMapOnLocation(location: CLLocationCoordinate2D) {
        locationManager.region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        if let selected = searchResults.first(where: { $0.mapItem.placemark.coordinate.latitude == location.latitude &&
            $0.mapItem.placemark.coordinate.longitude == location.longitude }) {
            selectedPlace = selected
        }
    }
    
    private func mapItemToLandmark(mapItem: MKMapItem) -> Landmark {
        return Landmark(
            id: UUID().uuidString,
            name: mapItem.name ?? "Unknown",
            address: mapItem.placemark.title ?? "",
            latitude: mapItem.placemark.coordinate.latitude,
            longitude: mapItem.placemark.coordinate.longitude
        )
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}









