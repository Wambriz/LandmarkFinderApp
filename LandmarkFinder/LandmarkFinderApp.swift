import SwiftUI
import Firebase


@main
struct LandmarkFinderApp: App {
    init() {
        FirebaseApp.configure()
        print("fireBase Configured!")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


