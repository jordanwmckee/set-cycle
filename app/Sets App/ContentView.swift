//
//  ContentView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       TabView {
          LibraryView()
             .tabItem {
                Image(systemName: "square.stack.fill")
             }
          SearchView()
             .tabItem {
                Image(systemName: "magnifyingglass")
             }
          ProfileView()
             .tabItem {
                Image(systemName: "person.fill")
             }
       }
    }
}

#Preview {
    ContentView()
}
