import SwiftUI
import MapKit

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var locationManager = LocationManager()
    @State private var searchResults = [Landmark]()

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search landmarks", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()

            // Splitting screen for results and map
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Search Results
                    List(searchResults, id: \.id) { landmark in
                        Text(landmark.name)
                            .onTapGesture {
                                
                            }
                    }
                    .frame(height: geometry.size.height / 2)

                    // Map View
                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                        .frame(height: geometry.size.height / 1.81)
                }
            }
        }
        .navigationBarTitle("Search Landmarks", displayMode: .inline)
    }

}

struct Landmark {
    var id: Int
    var name: String
    var location: CLLocationCoordinate2D
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}



