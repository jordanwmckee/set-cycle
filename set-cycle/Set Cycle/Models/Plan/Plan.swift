import Foundation

struct Plan: Identifiable, Equatable, Hashable, Decodable {
   let id: UUID
   var name: String
   var description: String
   var exercises: [Exercise]
   
   // Implement the Equatable protocol by defining the equality operator (==).
   static func == (lhs: Plan, rhs: Plan) -> Bool {
      return lhs.id == rhs.id
   }
}


struct Exercise: Hashable, Identifiable, Decodable {
   let id: UUID
   var name: String
   var video: String?
   var reps: [Rep]
}

struct Rep: Hashable, Identifiable, Decodable {
   let id: UUID
   var weight: Int
   var reps: Int
}
