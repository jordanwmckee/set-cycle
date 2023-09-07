//
//  LoginView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/27/23.
//

import SwiftUI

struct LoginView: View {
   @State private var username: String = ""
   @State private var password: String = ""
   
   var body: some View {
      TextField("Username", text: $username)
      TextField("Password", text: $password)
   }
}
