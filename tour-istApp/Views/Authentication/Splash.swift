import SwiftUI

struct Splash: View
{    
    // variables
    @State private var isActive: Bool = false

    // body
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        
            if isActive
            {
                LoginView()
                    .transition(.move(edge: .trailing))
            }
            else
            {
                logoView
            }
        }
        .onAppear
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
            {
                withAnimation
                {
                    isActive = true
                }
            }
        }
    }

    // logo view
    private var logoView: some View
    {
        VStack
        {
            Image("appLogoPng")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .scaleEffect(isActive ? 0.7 : 1.2)
                .opacity(isActive ? 0.5 : 1)
                .animation(.easeInOut(duration: 1.5), value: isActive)
        }
    }
}

#Preview
{
    Splash()
}
