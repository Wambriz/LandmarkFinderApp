import Foundation
import FirebaseFirestore

class LandmarkViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    
    // Function to fetch favorite landmarks
    func fetchFavoriteLandmarks(completion: @escaping ([Landmark]) -> Void) {
        db.collection("FavoriteLandmarks").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                var landmarks = [Landmark]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let address = data["address"] as? String ?? ""
                    let latitude = data["latitude"] as? Double ?? 0.0
                    let longitude = data["longitude"] as? Double ?? 0.0
                    let landmark = Landmark(id: document.documentID, name: name, address: address, latitude: latitude, longitude: longitude)
                    landmarks.append(landmark)
                }
                completion(landmarks)
            }
        }
    }
    
    // Function to add a favorite landmark
    func addFavoriteLandmark(landmark: Landmark) {
        db.collection("FavoriteLandmarks").addDocument(data: [
            "name": landmark.name,
            "address": landmark.address,
            "latitude": landmark.latitude,
            "longitude": landmark.longitude
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(landmark.id)")
            }
        }
    }
    
    // Function to remove a favorite landmark
    func removeFavoriteLandmark(landmarkId: String) {
        db.collection("FavoriteLandmarks").document(landmarkId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}

struct Landmark {
    var id: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    
}

