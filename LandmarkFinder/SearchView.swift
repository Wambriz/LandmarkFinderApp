import SwiftUI
import MapKit

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var locationManager = LocationManager()
    @State private var searchResults = [MKMapItem]()
    
    var body: some View {
        VStack {
            // Search Bar
            TextField("Search landmarks", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                .onChange(of: searchText) { newValue in
                    performSearch(query: newValue)
                }
            
            // Splitting screen for results and map
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Search Results
                    List(searchResults, id: \.name) { item in
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Unknown")
                            Text(item.placemark.title ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            // Handle selection of a place
                        }
                    }
                    .frame(height: geometry.size.height / 2)
                    
                    // Map View
                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                        .accentColor(Color(.systemPink))
                        .frame(height: geometry.size.height / 1.81)
                }
            }
        }
        .navigationBarTitle("Search Landmarks", displayMode: .inline)
    }
    
    private func performSearch(query: String) {
        locationManager.searchNearby(for: query) { results in
            self.searchResults = results
        }
    }
    
    
    struct SearchView_Previews: PreviewProvider {
        static var previews: some View {
            SearchView()
        }
    }
}



