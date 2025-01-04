import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TouristHomePage: View
{
    // MARK: - Properties
    @State var user: UserModel
    @State private var searchText: String = ""
    @State private var selectedTab: Int = 0
    @State private var posts: [PostModel] = []
    @State private var myPosts: [PostModel] = []
    @State private var showAddNewPost = false
    @State private var isProfileSheetPresented: Bool = false
    @State private var isNotificationSheetPresented: Bool = false

    private let db = Firestore.firestore()

    // MARK: - Body
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                headSection(user: user)
                Divider()
                middleSection
                Divider()
                postList
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear(perform: loadPosts)
            .sheet(isPresented: $showAddNewPost)
            {
                AddNewPost(isPresented: $showAddNewPost)
            }
            .sheet(isPresented: $isProfileSheetPresented)
            {
                OwnProfileView(user: user)
            }
            .sheet(isPresented: $isNotificationSheetPresented)
            {
                NotificationView(isPresented: $isNotificationSheetPresented)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Extensions for View Sections
private extension TouristHomePage
{
    // MARK: - Head Section
    func headSection(user: UserModel) -> some View
    {
        HStack
        {
            profileButton(user: user)
            Spacer()
            VStack
            {
                Text(user.name)
                    .font(.title)
                Text("Tourist")
                    .font(.title3)
            }
            Spacer()
            notificationButton
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }

    // MARK: Profile Button
    func profileButton(user: UserModel) -> some View
    {
        Button(action: { isProfileSheetPresented.toggle() })
        {
            if let url = URL(string: user.imageURL ?? "")
            {
                AsyncImage(url: url)
                { image in
                    image.resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .padding(.leading)
                }
                placeholder:
                {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            }
        }
    }

    // MARK: - Middle Section
    var middleSection: some View
    {
        VStack
        {
            SearchBar(text: $searchText)
                .padding()
            filterButtons
        }
    }

    // MARK: Filter Button
    func filterButton(title: String, tab: Int) -> some View
    {
        Button(action: { selectedTab = tab })
        {
            Text(title)
                .foregroundColor(selectedTab == tab ? .blue : .gray)
                .fontWeight(selectedTab == tab ? .bold : .regular)
        }
    }

    // MARK: Filter Buttons
    var filterButtons: some View
    {
        HStack
        {
            Spacer()
            filterButton(title: "Tüm İlanlar", tab: 0)
            Spacer()
            filterButton(title: "Benim İlanlarım", tab: 1)
            Spacer()
            Button("İlan Ekle")
            {
                showAddNewPost.toggle()
            }
            .padding(.trailing)
        }
    }
    
    // MARK: Post List
    var postList: some View
    {
        List(selectedTab == 0 ? posts : myPosts)
        { post in
            NavigationLink(destination: TouristPostDetailView(post: post))
            {
                PostRow(post: post)
            }
        }
        .listStyle(PlainListStyle())
    }

    
    // MARK: Notification Button
    var notificationButton: some View
    {
        Button(action: { isNotificationSheetPresented.toggle() })
        {
            Image(systemName: "bell.badge")
                .font(.title)
                .foregroundColor(.blue)
        }
        .padding(.trailing)
    }

    // MARK: Load Posts
    func loadPosts()
    {
        guard let currentUser = Auth.auth().currentUser else
        {
            print("No user is currently logged in.")
            return
        }

        db.collection("posts").getDocuments
        { snapshot, error in
            if let error = error
            {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else
            {
                print("No documents found.")
                return
            }

            let fetchedPosts = documents.compactMap
            { doc -> PostModel? in
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

            posts = fetchedPosts
            myPosts = fetchedPosts.filter { $0.ownerID == currentUser.uid }
        }
    }
}

// MARK: - Post Row
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
                { image in
                    image.resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                placeholder:
                {
                    ProgressView()
                        .frame(width: 50, height: 50)
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
            .padding()

            Spacer()

            Text(post.price.asCurrencyString())
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.trailing)
        }
    }
}
