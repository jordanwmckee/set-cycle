import Foundation

class PlanViewModel: ObservableObject {
   
   @Published var plans: [Plan]
   
   init() {
      // fetch data for plans
      plans = dummyPlans //?? []
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
   
   func modifyPlan(plan: Plan, planToEdit: Plan?) {
      let updatedPlan = Plan(
         name: plan.name,
         description: plan.description,
         exercises: plan.exercises.isEmpty ? [] : plan.exercises
      )
      
      if let index = plans.firstIndex(where: { $0.id == planToEdit?.id }) {
         // If editing, replace the existing plan with the updated one
         plans[index] = updatedPlan
      } else {
         // If creating a new plan, save it
         plans.append(updatedPlan)
      }
   }
   
   func deletePlan(plan: Plan) {
      if let index = plans.firstIndex(of: plan) {
         plans.remove(at: index)
      }
   }
   
   // MARK: - Exercise methods
   
   func nextExercise(plan: Plan) {
      if !plan.exercises.isEmpty, let index = plans.firstIndex(where: { $0.id == plan.id }) {
         let firstExercise = plans[index].exercises.removeFirst() // Remove and store the first element
         plans[index].exercises.append(firstExercise) // Append it back at the end
      }
   }
}
