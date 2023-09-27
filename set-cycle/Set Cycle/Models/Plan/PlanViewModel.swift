import Foundation

class PlanViewModel: ObservableObject {
   
   @Published var plans: [Plan] = []
   
   init() {
      var plans: [Plan] = []
      // fetch data for plans
      RequestManager.fetchUserPlans() { result in
         if let result = result {
            plans = result
         }
      }
      DispatchQueue.main.async {
         self.plans = plans
      }
   }
   
   // MARK: - Plan Methods
   
   #warning("refactor start, complete, makenext, and makelast to work with db")
   func startPlan(plan: Plan) {
      // move current plan to front of list and start
      if let idx = plans.firstIndex(of: plan) {
         plans.remove(at: idx) // Remove the item from its current position
         plans.insert(plan, at: 0) // Insert it at the front (index 0)
      }
   }
   
   func completePlan() {
      if !plans.isEmpty {
         let firstPlan = plans.removeFirst() // Remove and store the first element
         plans.append(firstPlan) // Append it back at the end
      }
   }
   
   func makePlanNext(plan: Plan) {
      if let index = plans.firstIndex(of: plan), index != 0 {
         plans.remove(at: index)
         plans.insert(plan, at: 1)
      }
   }
   
   func makePlanLast(plan: Plan) {
      if let index = plans.firstIndex(of: plan) {
         plans.remove(at: index)
         plans.append(plan)
      }
   }
   
   func modifyPlan(plan: Plan, modifyPlanID: UInt?) {
      
      var updatedPlan = Plan(
         id: plan.id,
         position: plan.position,
         name: plan.name,
         description: plan.description,
         exercises: plan.exercises.isEmpty ? [] : plan.exercises
      )
      
      // set order of exercises
      for i in 0..<updatedPlan.exercises.count {
         updatedPlan.exercises[i].position = i + 1
      }
      
      if let index = self.plans.firstIndex(where: { $0.id == modifyPlanID }) {
         // If editing, replace the existing plan with the updated one
         RequestManager.modifyPlan(for: updatedPlan) { plan in
            if let plan = plan {
               DispatchQueue.main.async {
                  self.plans[index] = plan
               }
            }
         }
      } else {
         // If creating a new plan, save it
         RequestManager.createPlan(with: updatedPlan) { plan in
            if let plan = plan {
               DispatchQueue.main.async {
                  self.plans.append(plan)
               }
            }
         }
      }
   }
   
   func updatePositions() {
      for (index, var plan) in plans.enumerated() {
         plan.position = index + 1
      }
   }
   
   func deletePlan(plan: Plan) {
      let err = RequestManager.deletePlan(for: plan)
      
      if err != nil {
         print("error: \(err!)")
         return
      }
      
      // if deletion was successful, update self.plans accordingly
      if let index = plans.firstIndex(of: plan) {
         plans.remove(at: index)
      }
      
   }
   
   // MARK: - Exercise methods
   
   #warning("modify functionality of cycling exercises")
   func nextExercise(plan: Plan) {
      if !plan.exercises.isEmpty, let index = plans.firstIndex(where: { $0.id == plan.id }) {
         let firstExercise = plans[index].exercises.removeFirst() // Remove and store the first element
         plans[index].exercises.append(firstExercise) // Append it back at the end
      }
   }
   
   func previousExercise(plan: Plan) {
      if !plan.exercises.isEmpty, let index = plans.firstIndex(where: { $0.id == plan.id }) {
         let lastExercise = plans[index].exercises.removeLast() // Remove and store the last element
         plans[index].exercises.insert(lastExercise, at: 0) // Insert it at the beginning
      }
   }
}
