import SwiftUI

struct TabBar: View {
   // miniplayer properties
   @State var expand = false
   @Namespace var animation
   
   
   // TODO: fetch data from api
   @StateObject var planViewModel = PlanViewModel()
   
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
         
         if let firstPlan = planViewModel.plans.first {
            Miniplayer(planViewModel: planViewModel, plan: firstPlan, animation: animation, expand: $expand)
         }
      }
   }
}
