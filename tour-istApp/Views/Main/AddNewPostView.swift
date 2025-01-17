import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseAuth

struct AddNewPostView: View
{
    // properties
    @Binding var isPresented: Bool

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var price: String = ""
    @State private var date: Date = Date()
    @State private var imageUrl: String = "https://shorturl.at/a9WRa"

    @State private var coordinate = Coordinate(coordinate: CLLocationCoordinate2D(latitude: 41.2867, longitude: 36.33))

    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false

    @State private var isDatePickerVisible: Bool = false
    @State private var isMapViewPresented: Bool = false

    // body
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                Form
                {
                    Section(header: Text("İlan Bilgileri").font(.headline))
                    {
                        TextField("İlan Başlığı", text: $title)
                        TextField("Açıklama", text: $description)
                        TextField("Resim URL'si", text: $imageUrl)
                        TextField("Konum", text: $location, onEditingChanged:
                                    { _ in
                            if !location.isEmpty {
                                self.searchPlaces(query: location)
                            }
                        })
                        .onChange(of: location) { newValue in
                            geocodeAddress(address: newValue)
                        }
                        .overlay
                        {
                            if isSearching
                            {
                                List(searchResults, id: \.self)
                                {
                                    item in
                                    Button(action: {
                                        self.location = item.name ?? ""
                                        self.coordinate = Coordinate(coordinate: item.placemark.coordinate)
                                        self.isSearching = false
                                    })
                                    {
                                        Text(item.name ?? "")
                                            .padding()
                                            .background(Color(UIColor.systemGray5))
                                            .cornerRadius(5)
                                    }
                                }
                                .frame(maxHeight: 200)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                        TextField("Fiyat", text: $price)
                            .keyboardType(.decimalPad)

                        Button(action: {
                            isDatePickerVisible.toggle()
                        })
                        {
                            HStack
                            {
                                Text("Tarih: \(formattedDate(date))")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        }

                        if isDatePickerVisible
                        {
                            DatePicker("Tarih", selection: $date, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .frame(maxHeight: 400)
                                .padding(.top, 8)
                        }
                    }

                    Section {
                        VStack {
                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
                                annotationItems: [coordinate]) { location in
                                MapPin(coordinate: location.coordinate, tint: .blue)
                            }
                            .frame(height: 250)
                            .cornerRadius(15)
                            .shadow(radius: 3)
                            .overlay(
                                Button(action: {
                                    isMapViewPresented.toggle()
                                }) {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(30)
                                        .shadow(radius: 2)
                                }
                                .padding()
                                .padding(.top, 10)
                                .padding(.trailing, 10),
                                alignment: .topTrailing
                            )
                        }
                    }
                }
                .navigationBarTitle("Yeni İlan Oluştur", displayMode: .inline)
                .navigationBarItems(trailing: Button("İptal") {
                    isPresented = false
                })

                Button(action: savePost) {
                    Text("Kaydet")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .sheet(isPresented: $isMapViewPresented)
        {
            ZStack
            {
                MapView()
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isMapViewPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .padding(6)
                                .frame(width: 25, height: 25)
                                .font(.title3)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .padding(.trailing, 15)
                    }
                    .padding(.top, 20)
                    Spacer()
                }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    private func savePost()
    {
        if let priceValue = Double(price), !title.isEmpty, !description.isEmpty, !location.isEmpty
        {
            guard (Auth.auth().currentUser?.uid) != nil
            else
            {
                print("Kullanıcı oturumu açmamış.")
                return
            }

            PostService.shared.addPost(
                title: title,
                description: description,
                date: date,
                location: location,
                price: priceValue,
                imageURL: imageUrl
            )
            {
                result in
                switch result {
                case .success(let post):
                    print("Post başarıyla eklendi: \(post.title)")
                    isPresented = false
                case .failure(let error):
                    print("Post eklenirken hata oluştu: \(error.localizedDescription)")
                }
            }
        }
        else
        {
            print("Fiyat veya ilan bilgileri geçersiz.")
        }
    }

    // geocode the adress
    private func geocodeAddress(address: String)
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error
            {
                print("Geocoding error: \(error)")
                self.coordinate = Coordinate(coordinate: CLLocationCoordinate2D(latitude: 41.2867, longitude: 36.33))
            } else if let placemark = placemarks?.first, let location = placemark.location {
                self.coordinate = Coordinate(coordinate: location.coordinate)
            }
        }
    }

    // search places func
    private func searchPlaces(query: String)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("Search error: \(error)")
                self.searchResults = []
                self.isSearching = false
            } else if let response = response {
                self.searchResults = response.mapItems
                self.isSearching = true
            }
        }
    }

    private func formattedDate(_ date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview
{
    AddNewPostView(isPresented: .constant(true))
}
