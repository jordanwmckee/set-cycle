//
//  ContentView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/26/23.
//

import SwiftUI

struct ContentView: View {
   @StateObject var authManager = AuthenticationManager.shared
   
   var body: some View {
      if authManager.isLoggedIn {
         TabBar()
      } else {
         LoginView()
      }
   }
}

#Preview {
    ContentView()
}
