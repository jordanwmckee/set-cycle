//
//  LoginViewModel.swift
//  Sets App
//
//  Created by Jordan McKee on 9/8/23.
//

import Foundation

class LoginViewModel: ObservableObject {
   @Published var credentials: UserCredentials
   
   init(credentials: UserCredentials? = nil) {
      if let creds = credentials {
         self.credentials = creds
      } else {
         self.credentials = UserCredentials(username: "", password: "")
      }
   }
   
   func login() {
      
      // validate credentials obj
      if credentials.username.isEmpty || credentials.password.isEmpty {
         print("Invalid credentials")
         return
      }
      
      // make request to api to login with given credentials
      makeRequest(
         endpoint: "/api/login",
         method: .post,
         body: credentials,
         responseType: LoginResponse.self
      ) { result in
         switch result {
         case .success(let data):
            if let data = data {
               // Handle successful response data
               print("Received response data: \(data)")
            } else {
               // Handle the case where there is no data (e.g., successful response with no content)
               print("Request successful with no data.")
            }
         case .failure(let response):
            // Handle the error response
            print("Error: \(response.message)")
         }
      }
   }
   
   func register() {
      
      // validate credentials obj
      if credentials.username.isEmpty || credentials.password.isEmpty {
         print("Invalid credentials")
         return
      }
      
      // make request to api to login with given credentials
      makeRequest(
         endpoint: "/api/register",
         method: .post,
         body: credentials,
         responseType: ApiResponse.self
      ) { result in
         switch result {
         case .success(let data):
            if let data = data {
               // Handle successful response data
               print("Received response data: \(data)")
            } else {
               // Handle the case where there is no data (e.g., successful response with no content)
               print("Request successful with no data.")
            }
         case .failure(let response):
            // Handle the error response
            print("Error: \(response.message)")
         }
      }
   }
}
