//
//  WorkoutDetails.swift
//  Sets App
//
//  Created by Jordan McKee on 8/27/23.
//

import Foundation

struct PlanInfo: Identifiable, Equatable {
   let id = UUID()
   let name: String
   let description: String
   let exercises: [Exercise]?
   
   // Implement the Equatable protocol by defining the equality operator (==).
   static func == (lhs: PlanInfo, rhs: PlanInfo) -> Bool {
      return lhs.id == rhs.id
   }
}
