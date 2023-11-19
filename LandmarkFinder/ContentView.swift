import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        // TODO Save Locations
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .padding()
                    }

                    Spacer()

                    Text("Landmark Finder")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        // TODO Search
                    }) {
                        NavigationLink(destination: SearchView()) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .padding()
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))
                .padding(.top, 16)
                .zIndex(1)

                // Map
                Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                            .edgesIgnoringSafeArea(.bottom)
                            .accentColor(Color(.systemPink))
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}






