import Foundation

class PlanViewModel: ObservableObject {
   
   @Published var plans: [Plan] = []
   
   init() {
      // fetch data for plans
      RequestManager.fetchUserPlans() { result in
         if let plans = result {
            DispatchQueue.main.async {
               self.plans = plans
            }
         }
      }
   }
   
   // MARK: - Plan Methods
   
   func startPlan(plan: Plan) {
      // move current plan to front of list and start
      if let idx = plans.firstIndex(of: plan) {
         plans.remove(at: idx) // Remove the item from its current position
         plans.insert(plan, at: 0) // Insert it at the front (index 0)
      }
   }
   
   func completePlan() {
      var firstPlan = plans.removeFirst() // Remove and store the first element
      firstPlan.position = plans.count // set position for update function
      plans.append(firstPlan) // Append it back at the end
      updatePositions() // update positions
      modifyPlan(plan: firstPlan, modifyPlanID: firstPlan.id) // save modified positions
   }
   
   
   func makePlanNext(plan: Plan) {
      if let index = plans.firstIndex(of: plan), index != 0 {
         // Remove the plan from its current position
         var removedPlan = plans.remove(at: index)
         removedPlan.position = 2
         
         // reinsert it at index 1 (next)
         plans.insert(removedPlan, at: 1)
         updatePositions()
   
         // Update plan order in db
         modifyPlan(plan: removedPlan, modifyPlanID: removedPlan.id)
      }
   }

   func makePlanLast(plan: Plan) {
      if let index = plans.firstIndex(of: plan) {
         // Remove the plan from its current position
         var removedPlan = plans.remove(at: index)
         removedPlan.position = plans.count
         
         // reinsert the plan at the end (last)
         plans.append(removedPlan)
         updatePositions()
         
         // Update plan order in db
         modifyPlan(plan: removedPlan, modifyPlanID: removedPlan.id)
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
