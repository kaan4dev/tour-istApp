import SwiftUI

struct TouristLastTabViewScreen: View {
    @State private var isActive: Bool = false

    var body: some View {
        ZStack {
            if isActive {
                NavigationView {
                    VStack(spacing: 0) {
                        NavigationLink(destination: TouristCityGuideView()) {
                            VStack {
                                Image("travelpic2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: UIScreen.main.bounds.height / 2)
                                    .clipped()
                                    .overlay(
                                        Text("Şehir İçin Gezi Rehberiniz")
                                            .font(.system(size: 50, weight: .bold))
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.7), radius: 5, x: 2, y: 2)
                                            .padding()
                                    )
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(15)
                            .padding()
                            .shadow(radius: 10)
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: LocationNewsView()) {
                            VStack {
                                Image("travelPic")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: UIScreen.main.bounds.height / 2)
                                    .clipped()
                                    .overlay(
                                        Text("Şehirden Haberler")
                                            .font(.system(size: 50, weight: .bold))
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.7), radius: 5, x: 2, y: 2)
                                            .padding()
                                    )
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(15)
                            .padding()
                            .shadow(radius: 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle("", displayMode: .inline)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.green.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all)
                    )
                }
            } else {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Şehirde kullanmak istediğiniz sanal rehber aracını seçin.")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                Image(systemName: "tool.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    TouristLastTabViewScreen()
}
