import Security
import Foundation

class KeychainService {
   
   // Service identifiers for refresh and access tokens
   static let refreshTokenService = "com.Sets-App.refreshToken"
   static let accessTokenService = "com.Sets-App.accessToken"
   
   static func saveRefreshTokenToKeychain(refreshToken: String) {
      saveTokenToKeychain(token: refreshToken, service: refreshTokenService)
   }
   
   static func retrieveRefreshTokenFromKeychain() -> String? {
      return retrieveTokenFromKeychain(service: refreshTokenService)
   }
   
   static func saveAccessTokenToKeychain(accessToken: String) {
      saveTokenToKeychain(token: accessToken, service: accessTokenService)
   }
   
   static func retrieveAccessTokenFromKeychain() -> String? {
      return retrieveTokenFromKeychain(service: accessTokenService)
   }
   
   static func deleteRefreshTokenFromKeychain() {
      deleteTokenFromKeychain(service: refreshTokenService)
   }
   
   static func deleteAccessTokenFromKeychain() {
      deleteTokenFromKeychain(service: accessTokenService)
   }
   
   private static func saveTokenToKeychain(token: String, service: String) {
      // Check if the item already exists
      if retrieveTokenFromKeychain(service: service) != nil {
         // The item already exists, so update it
         updateTokenInKeychain(token: token, service: service)
      } else {
         // The item does not exist, so create it
         createTokenInKeychain(token: token, service: service)
      }
   }
   
   private static func createTokenInKeychain(token: String, service: String) {
      let keychainQuery: [CFString: Any] = [
         kSecClass: kSecClassGenericPassword,
         kSecAttrService: service,
         kSecValueData: token.data(using: .utf8)!,
      ]
      
      let status = SecItemAdd(keychainQuery as CFDictionary, nil)
      
      if status != errSecSuccess {
         // Handle the error (e.g., log it or display an alert)
         print("Error creating token in Keychain: \(status)")
      }
   }
   
   private static func retrieveTokenFromKeychain(service: String) -> String? {
      let keychainQuery: [CFString: Any] = [
         kSecClass: kSecClassGenericPassword,
         kSecAttrService: service,
         kSecReturnData: true as Any,
         kSecMatchLimit: kSecMatchLimitOne,
      ]
      
      var item: CFTypeRef?
      let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)
      
      if status == errSecSuccess {
         if let data = item as? Data, let token = String(data: data, encoding: .utf8) {
            return token
         }
      } else if status != errSecItemNotFound {
         // Handle the error (e.g., log it or display an alert)
         print("Error retrieving token from Keychain: \(status)")
      }
      
      return nil
   }
   
   private static func updateTokenInKeychain(token: String, service: String) {
      let keychainQuery: [CFString: Any] = [
         kSecClass: kSecClassGenericPassword,
         kSecAttrService: service,
      ]
      
      let attributesToUpdate: [CFString: Any] = [
         kSecValueData: token.data(using: .utf8)!,
      ]
      
      let status = SecItemUpdate(keychainQuery as CFDictionary, attributesToUpdate as CFDictionary)
      
      if status != errSecSuccess {
         // Handle the error (e.g., log it or display an alert)
         print("Error updating token in Keychain: \(status)")
      }
   }
   
   private static func deleteTokenFromKeychain(service: String) {
      let keychainQuery: [CFString: Any] = [
         kSecClass: kSecClassGenericPassword,
         kSecAttrService: service,
      ]
      
      let status = SecItemDelete(keychainQuery as CFDictionary)
      
      if status != errSecSuccess && status != errSecItemNotFound {
         // Handle the error (e.g., log it or display an alert)
         print("Error deleting token from Keychain: \(status)")
      }
   }
}
