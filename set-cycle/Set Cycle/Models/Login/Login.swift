//
//  Login.swift
//  Set Cycle
//
//  Created by Jordan McKee on 9/8/23.
//

import Foundation

struct UserCredentials: Encodable {
   var apple_user_id: String
}

struct AuthenticateResponse: Decodable {
   var refresh_token: String
   var access_token: String
}

struct RefreshTokenResponse: Decodable {
   var refresh_token: String
}
