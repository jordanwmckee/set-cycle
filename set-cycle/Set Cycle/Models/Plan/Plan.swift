import Foundation

struct Plan: Identifiable, Equatable, Hashable, Codable {
   let id: UInt
   var name: String
   var description: String
   var exercises: [Exercise]
   
   // Define custom coding keys
   private enum CodingKeys: String, CodingKey {
      case id = "ID" // Map 'ID' to 'id' in the JSON response
      case name
      case description
      case exercises
   }
   
   // Implement the Equatable protocol by defining the equality operator (==).
   static func == (lhs: Plan, rhs: Plan) -> Bool {
      return lhs.id == rhs.id
   }
}


struct Exercise: Hashable, Identifiable, Codable {
   let id: UInt
   var name: String
   var video: String?
   var reps: [Rep]
   
   private enum CodingKeys: String, CodingKey {
      case id = "ID"
      case name
      case video
      case reps
   }
}

struct Rep: Hashable, Identifiable, Codable {
   let id: UInt
   var weight: Int
   var reps: Int
   
   private enum CodingKeys: String, CodingKey {
      case id = "ID"
      case weight
      case reps
   }
}
