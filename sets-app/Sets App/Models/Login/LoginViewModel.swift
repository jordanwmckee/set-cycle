//
//  LoginViewModel.swift
//  Sets App
//
//  Created by Jordan McKee on 9/8/23.
//

import Foundation
import AuthenticationServices

class LoginViewModel: ObservableObject {
   @Published var appleUserID: UserCredentials = UserCredentials(apple_user_id: "")
   
   // authenticate sends an api request to /authenticate to login or register user
   func authenticate(with appleID: ASAuthorizationAppleIDCredential) {
      appleUserID.apple_user_id = appleID.user
      
      // Make a request to the API to authenticate with the given credentials
      makeRequest(
         endpoint: "/api/authenticate",
         method: .post,
         body: appleUserID,
         responseType: LoginResponse.self
      ) { result in
         switch result {
         case .success(let tokens):
            if let tokens = tokens {
               // Handle successful response data
               print("Received response data: \(tokens)")
               
               // Store the refresh token in both memory and Keychain
               AuthenticationManager.shared.refreshToken = tokens.refresh_token
               KeychainService.saveRefreshTokenToKeychain(refreshToken: tokens.refresh_token)
               
               // Store the access token in memory (assuming it's included in the response)
               AuthenticationManager.shared.accessToken = tokens.access_token
               KeychainService.saveAccessTokenToKeychain(accessToken: tokens.access_token)
            }
         case .failure(let response):
            // Handle the error response
            print("Error: \(response.message)")
         }
      }
   }

}
