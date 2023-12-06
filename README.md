# Landmark Finder App
---
## Student Name: William Ambriz 
## SFSU-ID: 922117011
---
### Key Features
- **Easy Navigation**: Users can easily find their way to various landmarks with step-by-step directions.
- **Landmark Discovery**: The app allows users to search and explore landmarks in their vicinity or in specific areas.
- **Personalized Experience**: Users can save their favorite landmarks for quick access and future reference.

## Technical Summary

### Technologies Used
- **SwiftUI**: For building the user interface.
- **MapKit**: To integrate maps and provide location-based functionalities.
- **Firebase**: For backend data management and storing user preferences.
- **CoreLocation**: To access and manage the user’s location data.

### Core Components
1. **ContentView**: The primary view of the app, integrating navigation for landmarks list and search views.
2. **DirectionsView**: Displays routes from the user's location to selected landmarks.
3. **RouteView**: Embeds a map view in SwiftUI, displaying the calculated route.
4. **LandmarkFinderApp**: Main app structure, initializing Firebase.
5. **Firebase Configuration**: Includes plist files for setting up Firebase and managing location permissions.
6. **LandmarksListView**: Lists and manages user-saved landmarks.
7. **LandmarkViewModel**: Interacts with Firebase to handle data related to landmarks.
8. **LocationManager**: Manages location services for the app.
9. **SearchView**: Provides functionality to search for landmarks.
