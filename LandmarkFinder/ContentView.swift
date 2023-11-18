import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                    .padding(.leading)

                Spacer()

                Text("Landmark Finder")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .padding(.trailing)
            }
            .padding(.vertical)

            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

