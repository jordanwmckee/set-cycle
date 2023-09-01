//
//  ContentView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/26/23.
//

import SwiftUI

struct ContentView: View {
   @State var isLoggedIn = true
   
    var body: some View {
       if isLoggedIn {
          TabBar()
       } else {
          Text("No login")
       }
    }
}

#Preview {
    ContentView()
}
