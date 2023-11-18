import SwiftUI
import MapKit

struct Landmark: Identifiable {
    var id = UUID()
    var name: String
    var location: CLLocationCoordinate2D
}

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var locationManager = LocationManager()
    @State private var searchResults = [Landmark]()

    var body: some View {
        VStack {
            TextField("Search landmarks", text: $searchText, onCommit: {
                performSearch(query: searchText)
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()

            // Splitting screen for results and map
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    List(searchResults, id: \.id) { landmark in
                        Text(landmark.name)
                            .onTapGesture {
                                
                            }
                    }
                    .frame(height: geometry.size.height / 2)

                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                        .frame(height: geometry.size.height / 2)
                        .accentColor(Color(.systemPink))
                }
            }
        }
        .navigationBarTitle("Search Landmarks", displayMode: .inline)
    }

    func performSearch(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        // Use the current region from locationManager for search
        request.region = locationManager.region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            searchResults = response.mapItems.map { item in
                Landmark(name: item.name ?? "", location: item.placemark.coordinate)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}




