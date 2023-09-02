import SwiftUI

class SharedData: ObservableObject {
   @Published var expand: Bool = false
}

// using shared data
/*
 (parent view)
 import SwiftUI
 
 @main
 struct YourApp: App {
 @StateObject var sharedData = SharedData()
 
 var body: some Scene {
 WindowGroup {
 ContentView()
 .environmentObject(sharedData)
 }
 }
 }

 (any child view)
 import SwiftUI
 
 struct ChildView: View {
 @EnvironmentObject var sharedData: SharedData
 
 var body: some View {
 Toggle("Toggle", isOn: $sharedData.isFlagSet)
 }
 }

 */
