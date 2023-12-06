import SwiftUI

struct LandmarksListView: View {
    @StateObject private var landmarkVM = LandmarkViewModel()
    @State private var landmarks = [Landmark]()

    var body: some View {
        NavigationView {
            List(landmarks, id: \.id) { landmark in
                VStack(alignment: .leading) {
                    Text(landmark.name).font(.headline)
                    Text(landmark.address).font(.subheadline)
                }
            }
            .navigationBarTitle("Saved Landmarks", displayMode: .inline)
            .onAppear {
                landmarkVM.fetchFavoriteLandmarks { fetchedLandmarks in
                    self.landmarks = fetchedLandmarks
                }
            }
        }
    }
}


