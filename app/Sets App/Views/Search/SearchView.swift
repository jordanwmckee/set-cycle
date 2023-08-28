//
//  SearchView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/27/23.
//

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
