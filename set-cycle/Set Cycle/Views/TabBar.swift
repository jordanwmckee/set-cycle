import SwiftUI

struct TabBar: View {
   // miniplayer properties
   @State var expand = false
   @Namespace var animation
   
   @ObservedObject var planViewModel = PlanViewModel()
   
   // padding for views based on miniplayer
   private var miniPlayerPadding: EdgeInsets {
      return planViewModel.plans.first != nil ? EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0) : EdgeInsets()
   }
   
   var body: some View {
      ZStack(alignment: Alignment (horizontal: .center, vertical: .bottom)) {
         
         TabView {

            LibraryView(planViewModel: planViewModel)
               .tabItem {
                  Image(systemName: "square.stack.fill")
                  Text("Plans")
               }
               .padding(miniPlayerPadding)
            
            SearchView()
               .tabItem {
                  Image(systemName: "magnifyingglass")
                  Text("Search")
               }
               .padding(miniPlayerPadding)
            
            ProfileView()
               .tabItem {
                  Image(systemName: "person.fill")
                  Text("Profile")
               }
               .padding(miniPlayerPadding)
         }
         
         if let _ = planViewModel.plans.first {
            Miniplayer(planViewModel: planViewModel, plan: $planViewModel.plans.first!, animation: animation, expand: $expand)
         }
      }
   }
}
