import SwiftUI

struct SearchView: View {
   @State private var searchText: String = ""
   
   var body: some View {
      VStack(alignment: .trailing) {
         Spacer()
         SearchBar(placeholder: "Search for Users", text: $searchText)
            .padding(.horizontal)
      }
   }
}
