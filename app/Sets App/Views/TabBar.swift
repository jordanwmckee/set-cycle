import SwiftUI

struct TabBar: View {
   // miniplayer properties
   @State var expand = false
   @Namespace var animation
   @State var selectedPlan: Plan? = nil
   
   // padding for views based on miniplayer
   private var miniPlayerPadding: EdgeInsets {
      return selectedPlan != nil ? EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0) : EdgeInsets()
   }
   
   var body: some View {
      ZStack(alignment: Alignment (horizontal: .center, vertical: .bottom)) {
         TabView {
            LibraryView(selectedPlan: $selectedPlan)
               .tabItem {
                  Image(systemName: "square.stack.fill")
               }
               .padding(miniPlayerPadding)
            
            SearchView()
               .tabItem {
                  Image(systemName: "magnifyingglass")
               }
               .padding(miniPlayerPadding)
            
            ProfileView()
               .tabItem {
                  Image(systemName: "person.fill")
               }
               .padding(miniPlayerPadding)
         }
         
         if let _ = selectedPlan {
            Miniplayer(animation: animation, expand: $expand)
         }
      }
   }
}
