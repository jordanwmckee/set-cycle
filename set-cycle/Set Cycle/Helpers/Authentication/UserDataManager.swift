import Foundation

// This class will store non-sensitive user data in UserDefaults for the
// app to avoid excessive api requests upon startup
class UserDataManager {
   static let shared = UserDataManager()
   
   private let userDefaults = UserDefaults.standard
   private let userKey = "LoggedInUser"
   
   func saveLoggedInUser(username: String) {
      userDefaults.set(username, forKey: userKey)
   }
   
   func retrieveLoggedInUser() -> String? {
      return userDefaults.string(forKey: userKey)
   }
   
   func clearLoggedInUser() {
      userDefaults.removeObject(forKey: userKey)
   }
}
