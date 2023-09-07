import SwiftUI

struct ProfileView: View {
   
   var body: some View {
      VStack(spacing: 20) {
         Circle()
            .frame(height: 100)
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
         Text("Name")
         Text("handle")
      }
   }
}
