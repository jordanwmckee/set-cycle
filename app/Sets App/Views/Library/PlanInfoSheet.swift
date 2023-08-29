import SwiftUI

struct PlanInfoSheet: View {
   let plan: Plan
   @Binding var plans: [Plan]
   
   var body: some View {
      NavigationStack {
         VStack {
            // Workout title and description
            Text(plan.name)
               .font(.largeTitle)
            Text(plan.description)
               .font(.subheadline)
            
            // Exercise overview
            if let exercises = plan.exercises, !exercises.isEmpty {
               List(exercises, id: \.self) { exercise in
                  Section(header: Text(exercise.name)) {
                     VStack(alignment: .leading) {
                        List(0..<exercise.reps.count, id: \.self) { idx in
                           HStack {
                              Text("Weight: \(exercise.reps[idx].weight)")
                              Spacer()
                              Text("Reps: \(exercise.reps[idx].reps)")
                           }
                        }
                     }
                  }
               }
               .listStyle(.plain)
            }
         }
         .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               Button("Start") {
                  // Start workout
               }
            }
            ToolbarItem(placement: .navigationBarLeading) {
               NavigationLink(destination: ModifyPlanView(plans: $plans, planToEdit: plan)) {
                  Text("Edit")
               }
            }
         }
      }
      .navigationTitle("Plan Details")
   }
}
