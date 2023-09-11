import Security
import Foundation

class KeychainManager: ObservableObject {
   // Set username and password
   @Published var username: String?
   
   init(username: String? = nil) {
      // try to initialize with login credentials if given
      if let user = username {
         self.username = user
         return
      }
      
      // no credentials given, try to load them from keychain
   }
   
   // Update Keychain with user login info
   func setLoginInfo(password: String) throws {
      
      // convert password to data obj
      let pass = password.data(using: .utf8)!
      
      // Set attributes
      let attributes: [String: Any] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: username!,
         kSecValueData as String: pass,
         kSecAttrLabel as String: "credentials"
      ]
      // Add user
      if SecItemAdd(attributes as CFDictionary, nil) == noErr {
         print("User saved successfully in the keychain")
      } else {
         print("Something went wrong trying to save the user in the keychain")
      }
   }
   
   // retrieving user credentials
   func getLoginInfo() throws {
      
      // Set query
      let query: [String: Any] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: username!,
         kSecMatchLimit as String: kSecMatchLimitOne,
         kSecReturnAttributes as String: true,
         kSecReturnData as String: true,
      ]
      
      var item: CFTypeRef?
      
      // Check if user exists in the keychain
      if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
         // Extract result
         if let existingItem = item as? [String: Any],
            let username = existingItem[kSecAttrAccount as String] as? String,
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
         {
            print(username)
            print(password)
         }
      } else {
         print("Something went wrong trying to find the user in the keychain")
      }
   }
   
   // update user credentials stored in keychain with newer values
   func updateUserCredentials(for user: String, newPassword: Data) throws {
      
      // Set query
      let query: [String: Any] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: username!,
      ]
      
      // Set attributes for the new password
      let attributes: [String: Any] = [kSecValueData as String: newPassword]
      
      // Find user and update
      if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
         print("Password has changed")
      } else {
         print("Something went wrong trying to update the password")
      }
   }
   
   // only really to be called if user deletes their account or something
   func deleteUserCredentials() throws {
      
      // Set query
      let query: [String: Any] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: username!,
      ]
      
      // Find user and delete
      if SecItemDelete(query as CFDictionary) == noErr {
         print("User removed successfully from the keychain")
      } else {
         print("Something went wrong trying to remove the user from the keychain")
      }
   }
}
