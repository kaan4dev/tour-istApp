import SwiftUI
import FirebaseAuth

struct LoginView: View
{
    // MARK: - Variables
    @State private var selectedUserType: UserType?
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var userID: String?
    @State private var loginError: String?
    
    // MARK: - Body
    var body: some View
    {
        NavigationView
        {
            VStack(spacing: 40)
            {
                Spacer()
                
                headerView
                
                if selectedUserType == nil
                {
                    userTypeSelectionView
                } else
                {
                    loginFormView
                }
                
                Spacer()
            }
            .background(navigationLink)
            .navigationBarHidden(true)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
        }
    }
    
    // MARK: - Header View
    private var headerView: some View
    {
        VStack(spacing: 10)
        {
            Text("Tour-Ist App")
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(.white)
            
            Text("Kullanıcı Tipinizi Seçiniz.")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 50)
    }
    
    // MARK: - User Type Selection View
    private var userTypeSelectionView: some View
    {
        VStack(spacing: 20)
        {
            Button(action: { selectedUserType = .tourist })
            {
                Text("Turist")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 30)
            
            Button(action: { selectedUserType = .guide })
            {
                Text("Rehber")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 30)
        }
    }
    
    // MARK: - Login Form View
    private var loginFormView: some View
    {
        VStack(spacing: 20)
        {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(60)   
                .foregroundColor(.white)
                .padding(.horizontal, 30)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(60)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
            
            if let error = loginError
            {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button(action: loginUser)
            {
                Text("Log In")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 30)
        }
    }
    
    // MARK: - Navigation Link
    private var navigationLink: some View
    {
        NavigationLink(
            destination: MainTabView(userType: selectedUserType)
                .navigationBarBackButtonHidden(true),
            isActive: Binding<Bool>(
                get: { userID != nil },
                set: { if !$0 { userID = nil } }
            )
        )
        {
            EmptyView()
        }
    }
    
    // MARK: - Login User Function
    private func loginUser()
    {
        Auth.auth().signIn(withEmail: email, password: password)
        {
            result, error in
            if let error = error
            {
                loginError = error.localizedDescription
                print("Login error: \(error.localizedDescription)")
                return
            }
            if let userID = result?.user.uid
            {
                self.userID = userID
                loginError = nil
            }
        }
    }
}

// MARK: - Preview

#Preview
{
    LoginView()
}
