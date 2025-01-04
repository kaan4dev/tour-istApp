import SwiftUI

struct HomeView: View
{
    // properties
    var user: UserModel?

    //instances
    @State private var showSplash = true

    // body
    var body: some View
    {
        ZStack
        {
            if showSplash
            {
                SplashScreenView()
                    .transition(.opacity)
            }
            else
            {
                Group
                {
                    if let userType = user?.userType
                    {
                        if userType == .tourist
                        {
                            TouristHomePage(user: user!)
                        }
                        else if userType == .guide
                        {
                            GuideHomePage(user: user!)
                        }
                    }
                    else
                    {
                        Text("User type not selected.")
                    }
                }
                .transition(.opacity)
            }
        }
        .onAppear
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                withAnimation
                {
                    showSplash = false
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

// splash screen
struct SplashScreenView: View
{
    var body: some View
    {
        VStack
        {
            Image(systemName: "appLogoPng")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding()
            
            Text("Welcome to the Tour-Ist")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
