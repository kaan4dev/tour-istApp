import SwiftUI
import MapKit

struct TouristPostDetailView: View
{
    // variables
    @State var post: PostModel
    @State private var coordinate = CLLocationCoordinate2D(latitude: 41.2867, longitude: 36.33)
    @State private var annotation: LocationAnnotation?
    
    @State private var isLoading = false
    @State private var showEditView = false
    @State private var showDeletePostAlertView = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isFullDetailsPresented = false

    // body
    var body: some View
    {
        GeometryReader
        {
            geometry in
            VStack(spacing: 0)
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
            .onAppear
            {
                annotation = LocationAnnotation(coordinate: coordinate)
            }
            .alert(isPresented: $showAlert)
            {
                Alert(title: Text("Durum"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
            .sheet(isPresented: $showEditView)
            {
                editPostView()
            }
            .sheet(isPresented: $isFullDetailsPresented)
            {
                FullDetailsPage(isFullDetailsPresented: $isFullDetailsPresented, post: post)
            }
            .sheet(isPresented: $showDeletePostAlertView)
            {
                deletePostAlertView()
            }
        }
    }

    // geocode the location
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
    
    // post details view
    private func postDetailsView(geometry: GeometryProxy) -> some View
    {
        VStack(alignment: .leading)
        {
            HStack(spacing: 16)
            {
                postInfoView
                postImageView
            }
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.4)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
    }

    // post information view
    private var postInfoView: some View
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

    // post image view
    private var postImageView: some View
    {
        Group
        {
            if let imageURL = post.imageURL, let url = URL(string: imageURL)
            {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                        .shadow(radius: 7)
                }
                placeholder:
                {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
                .alignmentGuide(.top) { _ in 0 }
            }
        }
    }

    // map view
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

    // action buttons view
    private func actionButtonsView(geometry: GeometryProxy) -> some View
    {
        HStack(spacing: 0)
        {
            deleteButton
            Divider().frame(height: 40)
            editButton
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

    // delete button
    private var deleteButton: some View
    {
        Button(action: {
            showDeletePostAlertView = true
        })
        {
            Text("Sil")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.blue)
        .alert(isPresented: $showDeletePostAlertView) {
            Alert(
                title: Text("Gönderiyi Sil"),
                message: Text("Bu gönderiyi tamamen silmek istediğinize emin misiniz?"),
                primaryButton: .destructive(Text("Sil")) {
                    deletePost()
                },
                secondaryButton: .cancel(Text("Vazgeç"))
            )
        }
        .overlay(
            isLoading ? AnyView(ProgressView().progressViewStyle(CircularProgressViewStyle()).scaleEffect(2).frame(maxWidth: .infinity, maxHeight: .infinity)) : AnyView(EmptyView())
        )
    }

    // edit button
    private var editButton: some View
    {
        Button(action:
        {
            showEditView.toggle()
        })
        {
            Text("Düzenle")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.blue)
    }
    
    // delete post alert view
    private func deletePostAlertView() -> some View
    {
        VStack(spacing: 20)
        {
            Text("Bu gönderiyi silmek istediğinize emin misiniz?")
            
            HStack(spacing: 40)
            {
                Button
                {
                    showDeletePostAlertView.toggle()
                }
                label:
                {
                    Text("Vazgeç")
                        .frame(width: 100, height: 40)
                        .foregroundColor(.white)
                        .background(.blue.opacity(0.3))
                        .cornerRadius(80)
                }
                
                Button
                {
                    deletePost()
                }
                label:
                {
                    Text("Sil")
                        .frame(width: 100, height: 40)
                        .foregroundColor(.white)
                        .background(.red.opacity(0.3))
                        .cornerRadius(80)
                }
            }
        }
    }
    
    // edit post view
    private func editPostView() -> some View
    {
        NavigationView
        {
            VStack(alignment: .leading, spacing: 16)
            {
                Text("Gönderiyi Düzenle")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Başlık", text: Binding(
                    get: { post.title },
                    set: { post.title = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                TextField("Açıklama", text: Binding(
                    get: { post.description },
                    set: { post.description = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                TextField("Fiyat", value: Binding(
                    get: { post.price },
                    set: { post.price = $0 }
                ), formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)
                
                Spacer()
                
                saveButton
            }
            .padding()
            .navigationBarTitle("Düzenleme", displayMode: .inline)
            .navigationBarItems(trailing: Button("İptal")
            {
                showEditView = false
            })
        }
    }
    
    // delete post the function
    private func deletePost()
    {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5)
        {
            PostService.shared.deletePost(id: post.id)
            {
                result in
                isLoading = false
                
                switch result
                {
                case .success:
                    alertMessage = "Gönderi başarıyla silindi."
                    showAlert = true
                case .failure(let error):
                    alertMessage = "Silme hatası: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    // save button
    private var saveButton: some View
    {
        Button(action: {
            let updatedPost = PostModel(id: post.id, title: post.title, description: post.description, ownerID: post.ownerID, date: post.date, location: post.location, isActive: post.isActive, price: post.price, imageURL: post.imageURL)
            
            PostService.shared.updatePost(post: updatedPost)
            {
                result in
                switch result
                {
                case .success():
                    alertMessage = "Gönderi başarıyla güncellendi."
                    showAlert = true
                    showEditView = false
                case .failure(let error):
                    alertMessage = "Güncelleme hatası: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        })
        {
            Text("Kaydet")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
}

#Preview
{
    TouristPostDetailView(post: PostModel(id: "1", title: "İstanbul Turu", description: "Detaylı bir İstanbul turu.", ownerID: "10005", date: Date(), location: "İstanbul", isActive: true, price: 1200, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa8BEZilCGiEX2lhzGPeR__yCxH2awTwSMKx3NqyGP9i6uiuv2T8ddzOlUpzyP1u36wcQ&usqp=CAU"))
}
