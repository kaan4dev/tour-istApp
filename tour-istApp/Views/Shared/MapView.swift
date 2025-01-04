import SwiftUI
import MapKit

// MARK: Properties
struct MapView: View
{
    @StateObject private var locationManager = LocationManager()
    @State private var searchQuery: String = ""
    @State private var selectedLocations: [CLLocationCoordinate2D] = []
    @State private var distance: Double? = nil
    @State private var isDistancePresented = false
    @State private var city1: String = ""
    @State private var city2: String = ""

    @Environment(\.colorScheme) var colorScheme

    // MARK: Body
    var body: some View
    {
        NavigationView
        {
            GeometryReader { geometry in
                ZStack(alignment: .top)
                {
                    Map(coordinateRegion: $locationManager.region)
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geometry.size.width, height: geometry.size.height)

                    VStack(spacing: 20)
                    {
                        HStack
                        {
                            TextField("Bir şehir, mekan, konum adı giriniz...", text: $searchQuery, onCommit: {
                                searchLocation(query: searchQuery)
                            })
                            .padding()
                            .background(Color.gray.opacity(0.0))
                            .cornerRadius(10)
                            .padding(.horizontal)

                            Button(action: {
                                searchLocation(query: searchQuery)
                            })
                            {
                                Text("Ara")
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                    .background(Color.blue.opacity(colorScheme == .dark ? 0.5 : 0.7))
                                    .cornerRadius(8)
                            }
                            .padding(.trailing)
                        }
                        .background(Color.gray.opacity(colorScheme == .dark ? 0.3 : 0.7))
                        .cornerRadius(30)

                        HStack
                        {
                            Spacer()
                            VStack(spacing: 20)
                            {
                                Button(action: {
                                    isDistancePresented.toggle()
                                })
                                {
                                    Image(systemName: "arrow.right.arrow.left.circle")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                }

                                Button(action: {
                                    if let userLocation = locationManager.location
                                    {
                                        locationManager.region = MKCoordinateRegion(
                                            center: userLocation.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                        )
                                    }
                                })
                                {
                                    Image(systemName: "arrow.up.backward.circle")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                        .rotationEffect(.degrees(90))
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .sheet(isPresented: $isDistancePresented)
            {
                DistanceSheet(
                    city1: $city1,
                    city2: $city2,
                    selectedLocations: $selectedLocations,
                    distance: $distance,
                    isSheetPresented: $isDistancePresented
                )
            }
        }
    }

    // MARK: Location Manager
    class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate
    {
        // MARK: Properties
        private let locationManager = CLLocationManager()
        @Published var region: MKCoordinateRegion
        @Published var error: Error?
        
        var location: CLLocation?

        // MARK: Override
        override init()
        {
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 41.2867, longitude: 36.33),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            super.init()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            guard let location = locations.first else { return }
            self.location = location
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            self.error = error
        }
    }

    // MARK: Search Location
    func searchLocation(query: String)
    {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let response = response, let item = response.mapItems.first
            {
                let coordinate = item.placemark.coordinate
                locationManager.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
    }
}

// MARK: Distance Sheet
struct DistanceSheet: View
{
    @Binding var city1: String
    @Binding var city2: String
    @Binding var selectedLocations: [CLLocationCoordinate2D]
    @Binding var distance: Double?
    @Binding var isSheetPresented: Bool

    @Environment(\.colorScheme) var colorScheme

    @State private var isCalculating: Bool = false

    var body: some View
    {
        VStack
        {
            HStack
            {
                Button(action: {
                    isSheetPresented = false
                })
                {
                    Image(systemName: "xmark")
                        .font(.system(size: 25))
                        .foregroundColor(.gray)
                        .padding(.leading)
                }

                Spacer()
            }

            Spacer()

            Text("Mesafe Hesaplayıcı")
                .font(.headline)
                .fontWeight(.bold)
                .padding()

            VStack(spacing: 20)
            {
                TextField("Hesaplamak istediğiniz ilk şehir adını giriniz...", text: $city1)
                    .padding()
                    .background(Color.gray.opacity(colorScheme == .dark ? 0.3 : 0.7))
                    .cornerRadius(10)
                    .padding(.horizontal)

                TextField("Hesaplamak istediğiniz ikinci şehir adını giriniz...", text: $city2)
                    .padding()
                    .background(Color.gray.opacity(colorScheme == .dark ? 0.3 : 0.7))
                    .cornerRadius(10)
                    .padding(.horizontal)

                if isCalculating
                {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 10)
                }
                else
                {
                    Button(action: {
                        calculateDistances()
                    })
                    {
                        Text("Mesafeyi Hesapla")
                            .padding()
                            .background(Color.blue.opacity(0.0))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 20)

            if let distance = distance
            {
                Text("\(city1) ve \(city2) arasındaki mesafe: \(String(format: "%.2f", distance / 1000)) km")
                    .padding(.top, 20)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            selectedLocations.removeAll()
        }
    }
    
    // MARK: Calculate Distance
    func calculateDistances()
    {
        isCalculating = true
        searchLocation(query: city1, isFirstCity: true) { success1 in
            if success1
            {
                searchLocation(query: city2, isFirstCity: false) { success2 in
                    if success2 && selectedLocations.count == 2
                    {
                        calculateDistance()
                    }
                    isCalculating = false
                }
            }
            else
            {
                isCalculating = false
            }
        }
    }

    func searchLocation(query: String, isFirstCity: Bool, completion: @escaping (Bool) -> Void)
    {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query

        let search = MKLocalSearch(request: searchRequest)
        search.start
        {
            response, error in
            if let response = response, let item = response.mapItems.first
            {
                let coordinate = item.placemark.coordinate
                if isFirstCity
                {
                    if selectedLocations.count > 0
                    {
                        selectedLocations[0] = coordinate
                    }
                    else
                    {
                        selectedLocations.append(coordinate)
                    }
                }
                else
                {
                    if selectedLocations.count > 1
                    {
                        selectedLocations[1] = coordinate
                    }
                    else
                    {
                        selectedLocations.append(coordinate)
                    }
                }
                completion(true)
            }
            else
            {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }

    func calculateDistance()
    {
        guard selectedLocations.count == 2 else
        {
            print("İki şehir seçilmedi.")
            return
        }

        let loc1 = CLLocation(latitude: selectedLocations[0].latitude, longitude: selectedLocations[0].longitude)
        let loc2 = CLLocation(latitude: selectedLocations[1].latitude, longitude: selectedLocations[1].longitude)

        distance = loc1.distance(from: loc2)
    }
}

#Preview
{
    MapView()
}
