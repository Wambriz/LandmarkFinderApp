import SwiftUI

struct LandmarksListView: View {
    @StateObject private var landmarkVM = LandmarkViewModel()
    @State private var landmarks = [Landmark]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(landmarks, id: \.id) { landmark in
                    VStack(alignment: .leading) {
                        Text(landmark.name).font(.headline)
                        Text(landmark.address).font(.subheadline)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            removeLandmark(landmark)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
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
    
    private func removeLandmark(_ landmark: Landmark) {
        landmarkVM.removeFavoriteLandmark(landmarkId: landmark.id)
        landmarks.removeAll { $0.id == landmark.id }
    }
}



