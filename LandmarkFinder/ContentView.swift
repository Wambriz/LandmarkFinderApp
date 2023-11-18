import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

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
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                            .padding()
                    }
                }
                .background(Color(UIColor.systemBackground))
                .padding(.top, 16)
                .zIndex(1)

                // Map
                Map(coordinateRegion: $region)
                    .edgesIgnoringSafeArea(.bottom)
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






