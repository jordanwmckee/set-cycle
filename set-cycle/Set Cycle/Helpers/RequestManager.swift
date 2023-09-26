import Foundation

enum NetworkErrors: Error {
   case invalidURL
   case requestFailed(Error)
   case invalidResponse
   case unauthorized
   case badRequest
   case invalidBody
   case invalidData
   case internalServerError
}

enum HTTPMethod: String {
   case get = "GET"
   case put = "PUT"
   case post = "POST"
   case delete = "DELETE"
}

struct ApiResponse: Decodable, Error {
   let message: String
   
   init(_ message: String) {
      self.message = message
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
      // Attempt to decode the "message" key
      if let message = try? container.decode(String.self, forKey: .message) {
         self.message = message
      }
      // Attempt to decode the "error" key
      else if let error = try? container.decode(String.self, forKey: .error) {
         self.message = error
      }
      // Handle cases where neither "message" nor "error" key is present
      else {
         self.message = ""
      }
   }
   
   private enum CodingKeys: String, CodingKey {
      case message
      case error
   }
}

class RequestManager {

   // base url for all api requests to server
   static let baseURL: String = "http://localhost:8080"
   
   // MARK: - Template Network Request
   static func makeRequest<T: Decodable>(
      endpoint: String,
      method: HTTPMethod,
      body: Encodable? = nil,
      responseType: T.Type,
      accessToken: String? = nil,
      failOnUnauthorized: Bool = false,
      completion: @escaping (Result<T?, ApiResponse>) -> Void
   ) {
      // convert url string to url object
      guard let url = URL(string: baseURL + endpoint) else {
         completion(.failure(ApiResponse("invalid url")))
         return
      }

      // Build the request
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      // set authorization if accessToken passes
      if let accessToken = accessToken {
         request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
      }
      // set body of request if value passed
      if let body = body {
         do {
            let bodyJSON = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyJSON
         } catch {
            completion(.failure(ApiResponse("invalid body")))
         }
      }
            
      // Send request
      URLSession.shared.dataTask(with: request) { (data, response, error) in
         if let error = error {
            completion(.failure(ApiResponse(error.localizedDescription)))
            return
         }
         
         guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(ApiResponse(NetworkErrors.invalidResponse.localizedDescription)))
            return
         }
         
         // Set completion based on status code
         if (200...299).contains(httpResponse.statusCode) {
            if let data = data {
               do {
                  let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                  completion(.success(decodedResponse))
               } catch {
                  completion(.failure(ApiResponse("invalid response")))
               }
            } else {
               completion(.success(nil))
            }
         } else if httpResponse.statusCode == 401 {
            if failOnUnauthorized {
               completion(.failure(ApiResponse("unable to authenticate user")))
            }
            // response is unauthorized, try to refresh access token
            guard let refreshToken = KeychainService.retrieveRefreshTokenFromKeychain() else {
               completion(.failure(ApiResponse("unauthorized")))
               return
            }
            
            refreshAccessToken(token: refreshToken) { result in
               switch result {
               case .success(let data):
                  do {
                     if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let accessToken = json["access_token"] as? String {
                           // You have successfully retrieved the access token
                           AuthenticationManager.shared.accessToken = accessToken
                           print("token refreshed. \(accessToken)")
                           // Retry the original request with the new access token
                           makeRequest(
                              endpoint: endpoint,
                              method: method,
                              body: body,
                              responseType: responseType,
                              accessToken: accessToken,
                              failOnUnauthorized: true,
                              completion: completion
                           )
                        }
                     } else {
                        // Failed to parse JSON
                        completion(.failure(ApiResponse("failed to parse response")))
                     }
                  } catch {
                     // JSON parsing error
                     completion(.failure(ApiResponse("error: \(error)")))
                  }
                  
               case .failure(let error):
                  // Handle the failure case and the "error" here
                  // Your code for handling errors should go here.
                  print("refresh failed. error: \(error)")
               }
            }
            
         } else {
            if let data = data, let response = try? JSONDecoder().decode(ApiResponse.self, from: data) {
               completion(.failure(response))
            } else {
               completion(.failure(ApiResponse(NetworkErrors.requestFailed(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)).localizedDescription)))
            }
         }
      }.resume()
   }
   
   // Example Usage
   /*func makeAPIRequest() {
      let apiUrl = "/api/register"
      let body = UserCredentials(username: "username", password: "pass")
      
      makeRequest(endpoint: apiUrl, method: .post, body: body, responseType: ApiResponse.self) { result in
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
   }*/

   // MARK: - Refresh Token
   // Refresh the current user's access token
   static func refreshAccessToken(token: String, completion: @escaping (Result<Data, NetworkErrors>) -> Void) {
      
      // Construct the URL with the token as a query parameter
      guard var urlComponents = URLComponents(string: "\(baseURL)/api/refresh") else {
         completion(.failure(.invalidURL))
         return
      }
      
      urlComponents.queryItems = [URLQueryItem(name: "token", value: token)]
      
      guard let url = urlComponents.url else {
         completion(.failure(.invalidURL))
         return
      }
      
      // Create a POST request
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      
      // Perform the POST request
      URLSession.shared.dataTask(with: request) { (data, response, error) in
         if let error = error {
            completion(.failure(.requestFailed(error)))
            return
         }
         
         guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.invalidResponse))
            return
         }
         
         if (200...299).contains(httpResponse.statusCode) {
            // Successful response, return data
            if let data = data {
               completion(.success(data))
            } else {
               completion(.failure(.invalidResponse))
            }
         } else {
            // Handle non-successful response (e.g., 401 Unauthorized, 500 Internal Server Error)
            completion(.failure(.invalidResponse))
         }
      }.resume()
   }
   
   // MARK: - Register/Login
   
   static func authenticateUser(for user: UserCredentials, completion: @escaping (AuthenticateResponse?) -> Void) {
      makeRequest(
         endpoint: "/api/authenticate",
         method: .post,
         body: user,
         responseType: AuthenticateResponse.self
      ) { result in
         switch result {
         case .success(let tokens):
            completion(tokens) // Pass the tokens to the completion handler
         case .failure(let response):
            // Handle the error response
            print("Error: \(response.message)")
            completion(nil) // Pass nil to the completion handler in case of an error
         }
      }
   }

   
   // MARK: - Plan Requests
   
   // fetch all user plans from db on init
   static func fetchUserPlans(completion: @escaping ([Plan]?) -> Void){
      guard let token = AuthenticationManager.shared.accessToken else {
         completion(nil)
         return
      }
      
      // Make a request to the API to authenticate with the given credentials
      makeRequest(
         endpoint: "/api/plans/all",
         method: .get,
         responseType: [Plan].self,
         accessToken: token
      ) { result in
         switch result {
         case .success(let data):
            if let data = data {
               // Handle successful response data
               completion(data)
            }
         case .failure(let response):
            // Handle the error response
            print("error: \(response.message)")
            completion(nil)
         }
      }
   }
   
   // modifies a given plan for user
   static func modifyPlan(for plan: Plan) {
      guard let token = AuthenticationManager.shared.accessToken else {
         return
      }
      
      // Make a request to the API to authenticate with the given credentials
      makeRequest(
         endpoint: "/api/plans/modify/\(plan.id)",
         method: .put,
         body: plan,
         responseType: Plan.self,
         accessToken: token
      ) { result in
         switch result {
         case .success:
            print("Successfully update plan with id \(plan.id)")
         case .failure(let response):
            // Handle the error response
            print("Error: \(response.message)")
         }
      }
   }
   
   // create a given plan for user
   static func createPlan(with plan: Plan) {
      guard let token = AuthenticationManager.shared.accessToken else {
         return
      }
      
      // Make request to /plans/create
      makeRequest(
         endpoint: "/api/plans/create",
         method: .post,
         body: plan,
         responseType: Plan.self,
         accessToken: token
      ) { result in
         switch result {
            case .success:
               print("Created plan with id \(plan.id)")
            case .failure(let response):
               print("Error: \(response.message)")
         }
      }
   }
}


