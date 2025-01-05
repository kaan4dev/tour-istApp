import SwiftUI
import FirebaseAuth

struct MainTabView: View
{
    // properties
    @State private var selectedTab = 0
    @State private var showCreatePost = false
    @State private var user: UserModel?
    @State private var isLoading = true

    //instances
    var userType: UserType?

    var body: some View
    {
        TabView(selection: $selectedTab)
        {
            HomeView(user: user)
                .tabItem
                {
                    Image(systemName: "house")
                    Text("Ana Sayfa")
                }
                .tag(0)

            Group
            {
                if userType == .guide
                {
                    GuideTravelHistory()
                        .tabItem
                    {
                            Image(systemName: "arrow.3.trianglepath")
                            Text("Geçmiş")
                    }
                        .tag(1)
                }
                else
                {
                    MapView()
                        .tabItem
                        {
                            Image(systemName: "map")
                            Text("Araçlar")
                        }
                        .tag(1)
                        .edgesIgnoringSafeArea(.all)
                }
            }

            Group
            {
                if userType == .tourist
                {
                    Color.clear
                        .tabItem
                        {
                            Image(systemName: "plus.app")
                            Text("Yeni İlan")
                        }
                        .tag(2)
                        .onAppear
                        {
                            showCreatePost = true
                        }
                        .sheet(isPresented: $showCreatePost, onDismiss:
                        {
                            selectedTab = 0
                        })
                        {
                            AddNewPostView(isPresented: $showCreatePost)
                        }
                }
                else
                {
                    MapView()
                        .tabItem {
                            Image(systemName: "map")
                            Text("Harita")
                        }
                        .tag(2)
                        .edgesIgnoringSafeArea(.all)
                }
            }

            MessageView()
                .tabItem
                {
                    Image(systemName: "message")
                    Text("Mesajlar")
                }
                .tag(3)

            Group
            {
                if userType == .guide
                {
                    LocationNewsView()
                        .tabItem
                        {
                            Image(systemName: "newspaper")
                            Text("Haberler")
                        }
                        .tag(4)
                }
                else
                {
                    TouristLastTabViewScreen()
                        .tabItem
                        {
                            Image(systemName: "text.book.closed")
                            Text("Araştır")
                        }
                        .tag(4)
                }
            }
        }
        .accentColor(.blue)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: loadUserData)
        .alert(isPresented: $isLoading)
        {
            Alert(title: Text("Yükleniyor"), message: Text("Kullanıcı verileri yükleniyor..."), dismissButton: .default(Text("Tamam")))
        }
    }

    // load user data func
    private func loadUserData() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }

        UserService.shared.getUser(userID: currentUserID) { result in
            switch result {
            case .success(let fetchedUser):
                self.user = fetchedUser
            case .failure(let error):
                print("Kullanıcı verisi yüklenirken hata: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
}

#Preview
{
    MainTabView(userType: .tourist)
}
