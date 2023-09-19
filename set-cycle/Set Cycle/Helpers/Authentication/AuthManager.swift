//
//  AuthManager.swift
//  Set Cycle
//
//  Created by Jordan McKee on 9/11/23.
//

import Foundation

class AuthenticationManager: ObservableObject {
   static let shared = AuthenticationManager()
   
   init() {
      if refreshToken != nil {
         isLoggedIn = true
      }
   }
   
   // Check if the user is logged in
   @Published var isLoggedIn: Bool = false
   
   // Store tokens securely (e.g., in Keychain)
   var refreshToken: String? {
      get {
         return KeychainService.retrieveRefreshTokenFromKeychain()
      }
      set {
         if let newRefreshToken = newValue {
            KeychainService.saveRefreshTokenToKeychain(refreshToken: newRefreshToken)
         } else {
            // for removing token from keychain
            KeychainService.deleteRefreshTokenFromKeychain()
         }
      }
   }
   
   // Store tokens securely (e.g., in Keychain)
   var accessToken: String? {
      get {
         return KeychainService.retrieveAccessTokenFromKeychain()
      }
      set {
         if let newAccessToken = newValue {
            KeychainService.saveAccessTokenToKeychain(accessToken: newAccessToken)
         } else {
            // for removing token from keychain
            KeychainService.deleteAccessTokenFromKeychain()
         }
      }
   }
   
   // Additional user-related data (e.g., username)
   var username: String? {
      get {
         return UserDefaults.standard.string(forKey: "Username")
      }
      set {
         UserDefaults.standard.set(newValue, forKey: "Username")
      }
   }
   
   // Function to sign out
   func signOut() {
      refreshToken = nil
      isLoggedIn = false
      // TODO: Clear any other user-related data
   }
}
