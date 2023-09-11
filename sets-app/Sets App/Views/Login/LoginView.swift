import SwiftUI
import AuthenticationServices

struct LoginView: View {
   @ObservedObject var keychain: KeychainManager
   @Binding var isLoggedIn: Bool
   
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
               case let credential as ASAuthorizationAppleIDCredential:
                  
                  self.userId = credential.user
                  self.email = credential.email ?? ""
                  self.firstName = credential.fullName?.givenName ?? ""
                  self.lastName = credential.fullName?.familyName ?? ""
                  
//                  keychain.username = userId
//                  loginViewModel.credentials.username = "user"
//                  loginViewModel.credentials.password = "password"
//                  loginViewModel.login()
                  loginViewModel.credentials.username = (firstName + lastName).isEmpty ? "jordanmckee" : (firstName + lastName)
                  loginViewModel.credentials.password = "password"
                  loginViewModel.register()
                  isLoggedIn = true
                  
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
