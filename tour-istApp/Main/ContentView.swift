import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        VStack
        {
            Splash()
        }
        .ignoresSafeArea(.container, edges: .all)
    }
}

#Preview {
    ContentView()
}
