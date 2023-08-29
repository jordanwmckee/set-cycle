//
//  dummyData.swift
//  Sets App
//
//  Created by Jordan McKee on 8/28/23.
//

import Foundation

// Define dummy rep data
let dummyReps: [Rep] = [
   Rep(weight: 100, reps: 10),
   Rep(weight: 120, reps: 8),
   Rep(weight: 90, reps: 12)
]

// Define 7 dummy plans
let dummyPlans: [Plan] = [
   Plan(name: "Plan 1", description: "Description 1", exercises: [
      Exercise(name: "Exercise 1", weight: 50, reps: dummyReps),
      Exercise(name: "Exercise 2", weight: 60, reps: dummyReps)
   ]),
   Plan(name: "Plan 2", description: "Description 2", exercises: [
      Exercise(name: "Exercise 3", weight: 70, reps: dummyReps),
      Exercise(name: "Exercise 4", weight: 80, reps: dummyReps)
   ]),
   Plan(name: "Plan 3", description: "Description 3", exercises: [
      Exercise(name: "Exercise 5", weight: 90, reps: dummyReps)
   ]),
   Plan(name: "Plan 4", description: "Description 4", exercises: [
      Exercise(name: "Exercise 6", weight: 100, reps: dummyReps)
   ]),
   Plan(name: "Plan 5", description: "Description 5", exercises: [
      Exercise(name: "Exercise 7", weight: 110, reps: dummyReps),
      Exercise(name: "Exercise 8", weight: 120, reps: dummyReps)
   ]),
   Plan(name: "Plan 6", description: "Description 6", exercises: [
      Exercise(name: "Exercise 9", weight: 130, reps: dummyReps)
   ]),
   Plan(name: "Plan 7", description: "Description 7", exercises: [
      Exercise(name: "Exercise 10", weight: 140, reps: dummyReps),
      Exercise(name: "Exercise 11", weight: 150, reps: dummyReps)
   ])
   ]
