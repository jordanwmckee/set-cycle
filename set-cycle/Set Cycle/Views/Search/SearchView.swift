import SwiftUI

struct SearchView: View {
   @State private var searchText: String = ""
   
   var body: some View {
      ZStack(alignment: .top) {
         
         Image("anime")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
         

         SearchBar(placeholder: "Search for Users", text: $searchText)
            .safeAreaPadding(.vertical, 35)
            .padding(.horizontal)
      }
   }
}
