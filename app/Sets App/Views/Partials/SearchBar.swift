//
//  SearchBar.swift
//  Sets App
//
//  Created by Jordan McKee on 8/27/23.
//

import SwiftUI

struct SearchBar: View {
   var placeholder: String
   @Binding var text: String
   @Environment(\.colorScheme) var colorScheme
   
   var backgroundColor: Color {
      if colorScheme == .dark {
         return Color(.systemGray5)
      } else {
         return Color(.systemGray6)
      }
   }
   
   var body: some View {
      HStack {
         Image(systemName: "magnifyingglass").foregroundColor(.secondary)
         TextField(placeholder, text: $text)
         if text != "" {
            Image(systemName: "xmark.circle.fill")
               .imageScale(.medium)
               .foregroundColor(.secondary)//Color(backgroundColor))
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
