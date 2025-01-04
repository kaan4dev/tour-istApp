import SwiftUI
import FirebaseFirestore

struct GuideHomePage: View
{
    // properties
    let user: UserModel
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var isProfileSheetPresented = false
    @State private var isNotificationSheetPresented = false
    @State private var isSettingsSheetPresented = false
    @State private var posts: [PostModel] = []
    @State private var errorMessage: String?

    private let db = Firestore.firestore()

    // body
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                HeaderView(
                    user: user,
                    isProfileSheetPresented: $isProfileSheetPresented,
                    isNotificationSheetPresented: $isNotificationSheetPresented,
                    isSettingsSheetPresented: $isSettingsSheetPresented
                )

                Divider()

                MiddleSectionView(
                    searchText: $searchText,
                    selectedTab: $selectedTab
                )

                Divider()

                PostListView(posts: posts)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationBarHidden(true)
            .sheet(isPresented: $isProfileSheetPresented)
            {
                OwnProfileView(user: user)
            }
            .sheet(isPresented: $isNotificationSheetPresented)
            {
                NotificationView(isPresented: $isNotificationSheetPresented)
            }
            .sheet(isPresented: $isSettingsSheetPresented)
            {
                SettingsView()
            }
            .onAppear(perform: fetchPosts)
        }
    }
}

// header
extension GuideHomePage
{
    struct HeaderView: View
    {
        let user: UserModel
        @Binding var isProfileSheetPresented: Bool
        @Binding var isNotificationSheetPresented: Bool
        @Binding var isSettingsSheetPresented: Bool

        var body: some View
        {
            HStack
            {
                ProfileButton(
                    imageURL: user.imageURL,
                    action: { isProfileSheetPresented.toggle() }
                )

                Spacer()

                VStack
                {
                    Text(user.name)
                        .font(.title)
                    Text("Guide")
                        .font(.title3)
                }

                Spacer()

                HStack(spacing: 16)
                {
                    Button(action: { isNotificationSheetPresented.toggle() })
                    {
                        Image(systemName: "bell")
                            .font(.title)
                            .foregroundColor(.blue)
                    }

                    Button(action: { isSettingsSheetPresented.toggle() })
                    {
                        Image(systemName: "gearshape")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.trailing)
            }
            .padding()
        }
    }

    // profile button
    struct ProfileButton: View
    {
        let imageURL: String?
        let action: () -> Void

        var body: some View
        {
            Button(action: action)
            {
                if let url = URL(string: imageURL ?? "")
                {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                    placeholder:
                    {
                        ProgressView().frame(width: 50, height: 50)
                    }
                }
            }
            .padding(.leading)
        }
    }

    // middle
    struct MiddleSectionView: View
    {
        @Binding var searchText: String
        @Binding var selectedTab: Int

        var body: some View
        {
            VStack
            {
                SearchBar(text: $searchText).padding()

                HStack
                {
                    TabButton(title: "Tüm İlanlar", isSelected: selectedTab == 0)
                    {
                        selectedTab = 0
                    }

                    TabButton(title: "Başvurulan İlanlar", isSelected: selectedTab == 1)
                    {
                        selectedTab = 1
                    }
                }
            }
        }
    }

    // tab button
    struct TabButton: View
    {
        let title: String
        let isSelected: Bool
        let action: () -> Void

        var body: some View
        {
            Button(action: action)
            {
                Text(title)
                    .foregroundColor(isSelected ? .blue : .gray)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // post list view
    struct PostListView: View
    {
        let posts: [PostModel]

        var body: some View
        {
            List(posts)
            {
                post in
                NavigationLink(destination: GuidePostDetailView(post: post))
                {
                    PostRow(post: post)
                }
            }
            .listStyle(PlainListStyle())
        }
    }

    // post row
    struct PostRow: View
    {
        let post: PostModel

        var body: some View
        {
            HStack(spacing: 10)
            {
                if let url = URL(string: post.imageURL ?? "")
                {
                    AsyncImage(url: url)
                    {
                        image in
                        image.resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                    placeholder:
                    {
                        ProgressView().frame(width: 50, height: 50)
                    }
                }

                VStack(alignment: .leading)
                {
                    Text(post.title)
                        .font(.headline)
                    Text(post.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading)

                Spacer()

                Text(post.price.asCurrencyString())
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.trailing)
            }
        }
    }

    // fetch posts the function
    private func fetchPosts()
    {
        db.collection("posts").getDocuments
        {
            snapshot, error in
            if let error = error
            {
                errorMessage = error.localizedDescription
                return
            }

            guard let documents = snapshot?.documents else { return }

            posts = documents.compactMap
            {
                doc in
                let data = doc.data()
                return PostModel(
                    id: data["id"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    ownerID: data["ownerID"] as? String ?? "",
                    date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                    location: data["location"] as? String ?? "Unknown",
                    isActive: data["isActive"] as? Bool ?? true,
                    price: data["price"] as? Double ?? 0.0,
                    imageURL: data["imageURL"] as? String
                )
            }
        }
    }
}
