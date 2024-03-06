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
   
   // MARK: - Tokens
   var refreshToken: String? {
      get {
         return KeychainService.retrieveRefreshTokenFromKeychain()
      }
      set {
         if let newRefreshToken = newValue {
            KeychainService.saveRefreshTokenToKeychain(refreshToken: newRefreshToken)
         } else {
            KeychainService.deleteRefreshTokenFromKeychain()
         }
      }
   }
   
   var accessToken: String? {
      get {
         return KeychainService.retrieveAccessTokenFromKeychain()
      }
      set {
         if let newAccessToken = newValue {
            KeychainService.saveAccessTokenToKeychain(accessToken: newAccessToken)
         } else {
            KeychainService.deleteAccessTokenFromKeychain()
         }
      }
   }
   
   // MARK: - User Data
   // Additional user-related data (username, plans, etc for caching)
   var username: String? {
      get {
         return UserDataManager.shared.retrieveLoggedInUser()
      }
      set {
         if let newUsername = newValue {
            UserDataManager.shared.saveLoggedInUser(username: newUsername)
         } else {
            UserDataManager.shared.clearLoggedInUser()
         }
      }
   }
   
   // Function to sign out
   func signOut() {
      refreshToken = nil
      isLoggedIn = false
      // TODO: Clear any other user-related data
   }
}
