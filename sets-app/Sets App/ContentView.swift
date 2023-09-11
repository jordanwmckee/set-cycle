//
//  ContentView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/26/23.
//

import SwiftUI

struct ContentView: View {
   @StateObject var keychain = KeychainManager()
   @State var isLoggedIn = false
   
   var body: some View {
      if isLoggedIn {
         TabBar()
      } else {
         LoginView(keychain: keychain, isLoggedIn: $isLoggedIn)
      }
   }
}

#Preview {
    ContentView()
}
