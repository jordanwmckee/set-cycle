import SwiftUI

struct SearchBar: View {
   var placeholder: String
   @Binding var text: String
   
   var body: some View {
      HStack {
         Image(systemName: "magnifyingglass").foregroundColor(.secondary)
         TextField(placeholder, text: $text)
         if text != "" {
            Image(systemName: "xmark.circle.fill")
               .imageScale(.medium)
               .foregroundColor(.secondary)
               .padding(3)
               .onTapGesture {
                  withAnimation {
                     self.text = ""
                  }
               }
         }
      }
      .padding(10)
      .background(Color(.systemGray6))
      .cornerRadius(12)
      .padding(.vertical, 10)
   }
}
