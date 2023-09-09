import SwiftUI

struct ProfileView: View {
   @State private var responseText = "Response will appear here"
   @State private var response: ApiResponse? = nil
   
   var body: some View {
      VStack {
         Text(responseText)
            .padding()
         
         Button(action: {
            makeAPIRequest()
         }) {
            Text("Make API Request")
         }
      }
   }
   
   func makeAPIRequest() {
      let apiUrl = "/api/register"
      let body = UserCredentials(username: "username", password: "pass")
      
      makeRequest(endpoint: apiUrl, method: .post, body: body, responseType: ApiResponse.self) { result in
         switch result {
         case .success(let data):
            if let data = data {
               // Handle successful response data
               print("Received response data: \(data)")
               // Update the responseText with the API response data
               responseText = "API Response: \(data)" // Update the responseText here
            } else {
               // Handle the case where there is no data (e.g., successful response with no content)
               print("Request successful with no data.")
               // Update the responseText with a message
               responseText = "Request successful with no data."
            }
            
         case .failure(let response):
            // Handle the error response
            if let errorMessage = response.message {
               print("Error: \(errorMessage)")
               // Update the responseText with the error message
               responseText = "Error: \(errorMessage)"
            } else {
               // Handle other cases, such as invalid response or other errors
               print("Error: Unknown error")
               // Update the responseText with a generic error message
               responseText = "Error: Unknown error"
            }
         }
      }
   }
}
