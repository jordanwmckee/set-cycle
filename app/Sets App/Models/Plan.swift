import Foundation

struct Plan: Identifiable, Equatable, Hashable {
   let id = UUID()
   var name: String
   var description: String
   var exercises: [Exercise]?
   
   // Implement the Equatable protocol by defining the equality operator (==).
   static func == (lhs: Plan, rhs: Plan) -> Bool {
      return lhs.id == rhs.id
   }
}


struct Exercise: Hashable {
   var name: String
   var weight: Int
   var reps: [Rep]
}

struct Rep: Hashable {
   var weight: Int
   var reps: Int
}
