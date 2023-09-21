import SwiftUI
import AuthenticationServices

struct LoginView: View {
   @Environment (\.colorScheme) var colorScheme
   
   @ObservedObject var loginViewModel = LoginViewModel()

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
                     // attempt to login
                     loginViewModel.authenticate(with: credentials)
                  default:
                     print("credentials not returned properly")
                     break
               }
            case .failure (let error):
               // login failed, handle error appropriately
               print(error)
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
