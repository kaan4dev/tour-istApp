import SwiftUI
import Firebase

@main
struct tour_istAppApp: App
{
    init()
    {
        FirebaseApp.configure()
    }

    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .ignoresSafeArea(.container, edges: .all)
                .statusBar(hidden: true)
        }
    }
}
