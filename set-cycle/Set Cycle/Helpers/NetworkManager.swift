import Foundation

// func make network request
// @param url: String
// @param method: String
// @param body: [String: Any]?
// @param headers: [String: String]?
// @param completion: @escaping (Data?, URLResponse?, Error?) -> Void
// @return URLSessionDataTask

// The func will try to make the request, and return an erorr if it fails. If it fails due to expired token,
// it will try to refresh the token before failing back. 

// if the token is invalid, and we can't refresh it, we should probably log the user out