//
//  Login.swift
//  Sets App
//
//  Created by Jordan McKee on 9/8/23.
//

import Foundation

struct UserCredentials: Encodable {
   var username: String
   var password: String
}

struct LoginResponse: Decodable {
   var refresh_token: String
   var access_token: String
}

struct RefreshTokenResponse: Decodable {
   var refresh_token: String
}
