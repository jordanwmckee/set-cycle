import Foundation

struct ApiResponse: Decodable, Error {
   let message: String?
   
   init(message: String) {
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
         self.message = nil
      }
   }
   
   private enum CodingKeys: String, CodingKey {
      case message
      case error
   }
}


// base url for all api requests to server
let baseURL: String = "http://localhost:8080"
let refreshToken: String = "sometokenvalue"

func makeRequest<T: Decodable, U: Encodable>(
   endpoint: String,
   method: HTTPMethod,
   body: U? = nil,
   responseType: T.Type,
   accessToken: String? = nil,
   completion: @escaping (Result<T?, ApiResponse>) -> Void
) {
   // convert url string to url object
   guard let url = URL(string: baseURL + endpoint) else {
      completion(.failure(ApiResponse(message: "invalid url")))
      return
   }
   
   // Build the request
   var request = URLRequest(url: url)
   request.httpMethod = method.rawValue
   // set authorization if accessToken passes
   if let accessToken = accessToken {
      request.setValue(accessToken, forHTTPHeaderField: "Token")
   }
   // set body of request if value passed
   if let body = body {
      do {
         let bodyJSON = try JSONEncoder().encode(body)
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = bodyJSON
      } catch {
         completion(.failure(ApiResponse(message: "invalid body")))
      }
   }
   
   // Send request
   URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
         completion(.failure(ApiResponse(message: error.localizedDescription)))
         return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
         completion(.failure(ApiResponse(message: NetworkErrors.invalidResponse.localizedDescription)))
         return
      }
      
      // Set completion based on status code
      if (200...299).contains(httpResponse.statusCode) {
         if let data = data {
            do {
               let decodedResponse = try JSONDecoder().decode(T.self, from: data)
               completion(.success(decodedResponse))
            } catch {
               completion(.failure(ApiResponse(message: "invalid response")))
            }
         } else {
            completion(.success(nil))
         }
      } else {
         if let data = data, let response = try? JSONDecoder().decode(ApiResponse.self, from: data) {
            completion(.failure(response))
         } else {
            completion(.failure(ApiResponse(message: NetworkErrors.requestFailed(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)).localizedDescription)))
         }
      }
   }.resume()
}


// Example usage:
/*
let apiUrl = "/api/ping"
makeAuthorizedRequest(url: apiUrl, method: .get, responseType: MyResponseModel.self, accessToken: "yourAccessToken") { result in
   switch result {
   case .success(let response):
      print("Received response: \(response)")
   case .failure(let error):
      switch error {
      case .unauthorized:
         // Handle unauthorized error here (e.g., refresh token and retry the request)
         print("Received unauthorized error")
      default:
         // Handle other errors
         print("Error: \(error)")
      }
   }
}
 */

func refreshAccessToken(token: String, completion: @escaping (Result<Data, NetworkErrors>) -> Void) {

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
