import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var isShowingSidebar = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Button(action: {
                                withAnimation {
                                    isShowingSidebar.toggle()
                                }
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

                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .padding()
                        }
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                        .background(Color(UIColor.systemBackground))
                        .zIndex(1)

                        // Map
                        Map(coordinateRegion: $region)
                            .edgesIgnoringSafeArea(.bottom)
                    }

                    // Transparent background for dismissing the sidebar
                    if isShowingSidebar {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isShowingSidebar = false
                                }
                            }
                            .zIndex(0) // Ensures the overlay is below the sidebar
                    }

                    // Sidebar
                    if isShowingSidebar {
                        SidebarView()
                            .frame(width: geometry.size.width / 2)
                            .transition(.move(edge: .leading))
                            .background(Color(UIColor.systemBackground))
                            .zIndex(1) // Ensure the sidebar is above the overlay
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SidebarView: View {
    var body: some View {
        List {
            Text("Saved Locations")
        }
        .listStyle(SidebarListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



