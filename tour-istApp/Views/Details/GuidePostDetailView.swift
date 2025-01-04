import SwiftUI
import MapKit

struct GuidePostDetailView: View
{
    // MARK: - Variables
    var post: PostModel
    @State private var coordinate = CLLocationCoordinate2D(latitude: 41.2867, longitude: 36.33)
    @State private var annotation: LocationAnnotation?
    @State private var isFullDetailsPresented = false
    
    // MARK: - Body
    var body: some View
    {
        GeometryReader
        {
            geometry in
            VStack(spacing: 10)
            {
                postDetailsView(geometry: geometry)
                
                mapView(geometry: geometry)
                
                actionButtonsView(geometry: geometry)
            }
            .padding()
            .onAppear
            {
                geocodeLocation(post.location)
            }
        }
        .sheet(isPresented: $isFullDetailsPresented)
        {
            FullDetailsSheet(isFullDetailsPresented: $isFullDetailsPresented, post: post)
        }
    }

    // MARK: - Geocode the Location
    private func geocodeLocation(_ location: String)
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location)
        {
            placemarks, error in
            if let error = error
            {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first,
               let location = placemark.location
            {
                coordinate = location.coordinate
                annotation = LocationAnnotation(coordinate: coordinate)
            }
        }
    }

    // MARK: - Post Details View
    private func postDetailsView(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading)
        {
            HStack(spacing: 16)
            {
                postInfo
                postImage
            }
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.4)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Post Info
    private var postInfo: some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
            VStack(alignment: .leading, spacing: 8)
            {
                Text(post.title)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text(post.location)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("\(post.date, formatter: dateFormatter)")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text(post.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text(post.price.asCurrencyString())
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("Sahibi: \(post.ownerID)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Button
            {
                isFullDetailsPresented.toggle()
            }
            label:
            {
                Text("daha fazla bilgi...")
                    .foregroundColor(.blue)
                    .padding(.leading)
            }
        }
    }

    // MARK: - Post Image
    private var postImage: some View {
        Group {
            if let imageURL = post.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                        .shadow(radius: 7)
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
                .alignmentGuide(.top) { _ in 0 }
            }
        }
    }

    // MARK: - Map View
    private func mapView(geometry: GeometryProxy) -> some View
    {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))),
            annotationItems: annotation != nil ? [annotation!] : []) { location in
            MapPin(coordinate: location.coordinate, tint: .blue)
        }
        .frame(height: geometry.size.height * 0.4)
        .cornerRadius(15)
        .shadow(radius: 3)
        .padding(.bottom, 20)
        .padding(.top, 10)
    }

    // MARK: - Action Buttons View
    private func actionButtonsView(geometry: GeometryProxy) -> some View
    {
        HStack(spacing: 0) {
            messageButton
            Divider().frame(height: 40)
            applyButton
            Divider().frame(height: 40)
            phoneButton
        }
        .font(.system(size: 17, weight: .bold))
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(30)
        .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 5)
        .padding(.top, 10)
        .frame(maxWidth: 300, maxHeight: 100)
    }

    // MARK: - Message Button
    private var messageButton: some View
    {
        Button(action: {})
        {
            VStack
            {
                Image(systemName: "message")
                    .font(.body)
                    .foregroundColor(.white)

                Text("Mesaj")
                    .foregroundColor(.white)
                    .bold()
                    .font(.body)
            }
        }
        .padding()
        .background(Color.blue)
    }

    // MARK: - Apply Button
    private var applyButton: some View
    {
        Button(action: {})
        {
            VStack
            {
                Image(systemName: "paperplane")
                    .font(.body)
                    .foregroundColor(.white)

                Text("Başvur")
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.blue)
    }

    // MARK: - Phone Button
    private var phoneButton: some View
    {
        Button(action: {})
        {
            VStack
            {
                Image(systemName: "phone")
                    .font(.body)
                    .foregroundColor(.white)

                Text("Telefon")
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.blue)
    }
}

#Preview
{
    GuidePostDetailView(post: PostModel(id: "1", title: "İstanbul Turu", description: "Detaylı bir İstanbul turu.", ownerID: "10005", date: Date(), location: "İstanbul", isActive: true, price: 1200, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa8BEZilCGiEX2lhzGPeR__yCxH2awTwSMKx3NqyGP9i6uiuv2T8ddzOlUpzyP1u36wcQ&usqp=CAU"))
}
    
