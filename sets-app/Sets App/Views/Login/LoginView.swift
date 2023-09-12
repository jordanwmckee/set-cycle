import SwiftUI
import AuthenticationServices

struct LoginView: View {
   @Environment (\.colorScheme) var colorScheme
   
   @ObservedObject var loginViewModel = LoginViewModel()
   
   // cached data
   @AppStorage("email") var email: String = ""
   @AppStorage("firstName") var firstName: String = ""
   @AppStorage("lastName") var lastName: String = ""
   @AppStorage("userId") var userId: String = ""

   var body: some View {
      
      VStack {
         Text("Login View")
            .font(.largeTitle)
            .padding()
         
         SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
         } onCompletion: { result in
            
            switch result {
            case .success (let auth):
               // login success, get credentials
               switch auth.credential {
               case let credentials as ASAuthorizationAppleIDCredential:
                  // try to register/login
                  loginViewModel.authenticate(with: credentials)
                  // if successful, AuthenticationManager.shared.refreshToken
                  // will no longer be nil, meaning isLoggedIn will be true
               default:
                  break
               }
               
            case .failure (let error):
               // login failed, handle error appropriately
               print (error)
            }
         }
         .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
         )
         .frame(height: 50)
         .padding()
      }
   }
}
