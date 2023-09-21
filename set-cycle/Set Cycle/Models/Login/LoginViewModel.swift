//
//  LoginViewModel.swift
//  Set Cycle
//
//  Created by Jordan McKee on 9/8/23.
//

import Foundation
import AuthenticationServices

class LoginViewModel: ObservableObject {
   // authenticate sends an api request to /authenticate to login or register user
   func authenticate(with appleID: ASAuthorizationAppleIDCredential) {
      let user = UserCredentials(apple_user_id: appleID.user)

      RequestManager.authenticateUser(for: user) { tokenResponse in
         if let tokens = tokenResponse {
            // publish new data from main thread
            DispatchQueue.main.async {
               // Store the refresh token in both memory and Keychain
               AuthenticationManager.shared.refreshToken = tokens.refresh_token
               KeychainService.saveRefreshTokenToKeychain(refreshToken: tokens.refresh_token)
               
               // Store the access token in memory (assuming it's included in the response)
               AuthenticationManager.shared.accessToken = tokens.access_token
               KeychainService.saveAccessTokenToKeychain(accessToken: tokens.access_token)
               
               AuthenticationManager.shared.isLoggedIn = true
            }
         } else {
            print("Unable to authenticate user")
         }
      }
   }
}
