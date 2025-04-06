import SwiftUI
import MapKit
import CoreLocation

// Location Manager to handle location services
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Default location set to Tysons Corner, VA
        self.location = CLLocation(latitude: 38.9187, longitude: -77.2311)
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

struct PollingPlace: Hashable, Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String
    var type: PlaceType
    var address: String
    var distance: Double? // in meters
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(title)
        hasher.combine(type)
        hasher.combine(address)
        hasher.combine(distance)
    }
    
    static func == (lhs: PollingPlace, rhs: PollingPlace) -> Bool {
        return lhs.id == rhs.id &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude &&
               lhs.title == rhs.title &&
               lhs.type == rhs.type &&
               lhs.address == rhs.address &&
               lhs.distance == rhs.distance
    }
    
    enum PlaceType: String {
        case school = "School"
        case library = "Library"
        case communityCenter = "Community Center"
        case governmentBuilding = "Government Building"
        case church = "Church"
        case other = "Other"
        
        var iconName: String {
            switch self {
            case .school: return "building.columns.fill"
            case .library: return "books.vertical.fill"
            case .communityCenter: return "person.3.fill"
            case .governmentBuilding: return "building.2.fill"
            case .church: return "building.fill"
            case .other: return "mappin.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .school: return .blue
            case .library: return .purple
            case .communityCenter: return .green
            case .governmentBuilding: return .orange
            case .church: return .red
            case .other: return .gray
            }
        }
    }
}

struct PollingPlacesView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var pollingPlaces: [PollingPlace] = []
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var showLocationPermissionAlert = false
    @State private var selectedPlace: PollingPlace?
    @State private var showDetailsSheet = false
    @State private var searchRadius: Double = 5000 // 5km default
    
    // Your exact location in decimal degrees
    let userLocation = CLLocationCoordinate2D(latitude: 38.911944, longitude: -77.2225)
    
    // Hardcoded polling places in Tysons Corner, VA
    let pollingPlacesTysons = [
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9187, longitude: -77.2311),
            title: "Tysons Corner Center",
            type: .other,
            address: "1961 Chain Bridge Rd, Tysons, VA 22102",
            distance: nil
        ),
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9210, longitude: -77.2390),
            title: "Westbriar Elementary School",
            type: .school,
            address: "1741 Pine Valley Dr, Vienna, VA 22182",
            distance: nil
        ),
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9145, longitude: -77.2215),
            title: "Tysons-Pimmit Regional Library",
            type: .library,
            address: "7584 Leesburg Pike, Falls Church, VA 22043",
            distance: nil
        ),
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9250, longitude: -77.2350),
            title: "First Baptist Church of Vienna",
            type: .church,
            address: "450 Orchard St NW, Vienna, VA 22180",
            distance: nil
        ),
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9100, longitude: -77.2400),
            title: "McLean Community Center",
            type: .communityCenter,
            address: "1234 Ingleside Ave, McLean, VA 22101",
            distance: nil
        ),
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9300, longitude: -77.2250),
            title: "Vienna Town Hall",
            type: .governmentBuilding,
            address: "127 Center St S, Vienna, VA 22180",
            distance: nil
        ),
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9050, longitude: -77.2300),
            title: "McLean High School",
            type: .school,
            address: "1633 Davidson Rd, McLean, VA 22101",
            distance: nil
        ),
        PollingPlace(
            coordinate: CLLocationCoordinate2D(latitude: 38.9200, longitude: -77.2150),
            title: "Patrick Henry Library",
            type: .library,
            address: "101 Maple Ave E, Vienna, VA 22180",
            distance: nil
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map view
                Map(
                    position: $cameraPosition,
                    interactionModes: .all,
                    selection: $selectedPlace
                ) {
                    // Show user location
                    UserAnnotation()
                    
                    // Show polling places
                    ForEach(pollingPlaces) { place in
                        Marker(place.title, coordinate: place.coordinate)
                            .tint(place.type.color)
                    }
                }
                .mapStyle(.standard)
                .edgesIgnoringSafeArea(.top)
                .onAppear {
                    // Immediately load polling places with user's exact location
                    cameraPosition = .region(MKCoordinateRegion(
                        center: userLocation,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                    loadPollingPlaces(from: userLocation)
                    setupLocationManager()
                }
                .onChange(of: locationManager.location) { _, newLocation in
                    if let location = newLocation {
                        withAnimation {
                            cameraPosition = .region(MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            ))
                        }
                        if pollingPlaces.isEmpty {
                            loadPollingPlaces(from: userLocation)
                        }
                    }
                }
                
                // Bottom Card with Polling Places List
                VStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        // Handle Bar
                        RoundedRectangle(cornerRadius: 3)
                            .frame(width: 40, height: 6)
                            .foregroundColor(.gray.opacity(0.3))
                            .padding(.top, 8)
                        
                        // Header
                        HStack {
                            Text("Tysons Corner Polling Places")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Menu {
                                Button("1 km") { searchRadius = 1000; refreshPollingPlaces() }
                                Button("5 km") { searchRadius = 5000; refreshPollingPlaces() }
                                Button("10 km") { searchRadius = 10000; refreshPollingPlaces() }
                                Button("25 km") { searchRadius = 25000; refreshPollingPlaces() }
                            } label: {
                                HStack {
                                    Text("\(Int(searchRadius/1000)) km")
                                    Image(systemName: "chevron.down")
                                }
                                .padding(6)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Polling Places List
                        if pollingPlaces.isEmpty {
                            Text("No polling places found nearby. Try increasing your search radius.")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            List {
                                ForEach(pollingPlaces.sorted { ($0.distance ?? 0) < ($1.distance ?? 0) }) { place in
                                    Button(action: {
                                        selectedPlace = place
                                        // Center map on selected place
                                        withAnimation {
                                            cameraPosition = .region(MKCoordinateRegion(
                                                center: place.coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                            ))
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: place.type.iconName)
                                                .foregroundColor(place.type.color)
                                                .frame(width: 30)
                                            
                                            VStack(alignment: .leading) {
                                                Text(place.title)
                                                    .font(.system(size: 16))
                                                    .fontWeight(.medium)
                                                
                                                Text(place.address)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            if let distance = place.distance {
                                                Text(formatDistance(distance))
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(selectedPlace?.id == place.id ? Color.blue.opacity(0.1) : Color.clear)
                                        .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(height: 250)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -3)
                }
                
                // Control Buttons
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 12) {
                            // Globe Button to zoom out and show all locations
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    if !pollingPlaces.isEmpty {
                                        let coordinates = pollingPlaces.map { $0.coordinate }
                                        cameraPosition = .region(regionThatFitsCoordinates(coordinates))
                                        selectedPlace = nil
                                    }
                                }
                            }) {
                                Image(systemName: "globe.americas.fill")
                                    .font(.system(size: 24))
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            
                            // Recenter Button - Navigates to your exact location
                            Button(action: {
                                withAnimation {
                                    cameraPosition = .region(MKCoordinateRegion(
                                        center: userLocation,
                                        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
                                    ))
                                }
                            }) {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 24))
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Tysons Corner Polling Places")
                    .font(.headline)
                    .fontWeight(.bold),
                trailing: Button(action: {
                    refreshPollingPlaces()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            )
            .alert(isPresented: $showLocationPermissionAlert) {
                Alert(
                    title: Text("Location Access Required"),
                    message: Text("Please enable location access in your device settings to find polling places near you."),
                    primaryButton: .default(Text("Open Settings"), action: openSettings),
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showDetailsSheet) {
                if let selectedPlace = selectedPlace {
                    PollingPlaceDetailView(place: selectedPlace)
                }
            }
            .onChange(of: selectedPlace) { _, newPlace in
                showDetailsSheet = newPlace != nil
            }
        }
    }
    
    func setupLocationManager() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            showLocationPermissionAlert = true
        @unknown default:
            break
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func refreshPollingPlaces() {
        // Always use the user's exact location for refreshing
        loadPollingPlaces(from: userLocation)
    }
    
    func loadPollingPlaces(from userLocation: CLLocationCoordinate2D) {
        // Use our hardcoded polling places
        var filteredPlaces = pollingPlacesTysons
        
        // Update distances based on the provided user location
        for i in 0..<filteredPlaces.count {
            let placeCoordinate = filteredPlaces[i].coordinate
            let locationDistance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                .distance(from: CLLocation(latitude: placeCoordinate.latitude, longitude: placeCoordinate.longitude))
            
            filteredPlaces[i].distance = locationDistance
        }
        
        // Filter by search radius
        filteredPlaces = filteredPlaces.filter { ($0.distance ?? 0) <= searchRadius }
        
        // Set the polling places
        pollingPlaces = filteredPlaces
    }
    
    func openInMaps(_ place: PollingPlace) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
        mapItem.name = place.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func formatDistance(_ meters: Double) -> String {
        if meters < 1000 {
            return "\(Int(meters))m"
        } else {
            let kilometers = meters / 1000
            return String(format: "%.1fkm", kilometers)
        }
    }
    
    // Function to calculate a region that fits all coordinates
    func regionThatFitsCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLon: CLLocationDegrees = 180.0
        var maxLon: CLLocationDegrees = -180.0
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.3, // Add 30% padding
            longitudeDelta: (maxLon - minLon) * 1.3
        )
        return MKCoordinateRegion(center: center, span: span)
    }
}

struct PollingPlaceDetailView: View {
    let place: PollingPlace
    @State private var showDirections = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with type icon
                    HStack {
                        Image(systemName: place.type.iconName)
                            .font(.largeTitle)
                            .foregroundColor(place.type.color)
                        
                        VStack(alignment: .leading) {
                            Text(place.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(place.type.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical)
                    
                    // Address
                    VStack(alignment: .leading) {
                        Text("Address")
                            .font(.headline)
                        
                        Text(place.address)
                            .font(.body)
                    }
                    
                    // Distance
                    if let distance = place.distance {
                        VStack(alignment: .leading) {
                            Text("Distance")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                Text(distance < 1000 ? "\(Int(distance)) meters" : String(format: "%.2f kilometers", distance / 1000))
                            }
                        }
                    }
                    
                    // Hours - Virginia polls are open 6am-7pm
                    VStack(alignment: .leading) {
                        Text("Voting Hours")
                            .font(.headline)
                        
                        Text("6:00 AM - 7:00 PM")
                            .font(.body)
                        
                        Text("*Virginia polls are open from 6am to 7pm on Election Day.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    
                    // Accessibility info
                    VStack(alignment: .leading) {
                        Text("Accessibility")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "figure.roll")
                            Text("Wheelchair accessible")
                        }
                        
                        HStack {
                            Image(systemName: "car.fill")
                            Text("Parking available")
                        }
                    }
                    
                    // "I Voted" Sticker Preview
                    VStack(alignment: .center) {
                        Text("Check in here to earn")
                            .font(.headline)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding()
                        
                        Text("Digital \"I Voted\" sticker")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
                            mapItem.name = place.title
                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                        }) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Get Directions")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // Add to calendar
                        }) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                Text("Add to Calendar")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Polling Place Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            })
        }
    }
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct PollingPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PollingPlacesView()
    }
}
