//
//  LoginViewModel.swift
//  Sets App
//
//  Created by Jordan McKee on 9/8/23.
//

import Foundation

class LoginViewModel: ObservableObject {
   @Published var credentials: UserCredentials
   
   init(credentials: UserCredentials) {
      self.credentials = credentials
   }
   
   func Login() {
      
   }
}
