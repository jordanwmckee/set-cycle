import SwiftUI

struct PlanInfoView: View {
   let plan: Plan
   @Binding var plans: [Plan]
   
   var body: some View {
      
      NavigationStack {
         
         VStack {

            Text(plan.description)
               .font(.subheadline)
               .padding(.bottom)
            
            // Exercise overview
            if !plan.exercises.isEmpty {
               
               List(plan.exercises, id: \.self) { exercise in
                  
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
            
            Spacer(minLength: 0)
            
            Button(action: {
               // move current plan to front of list
               if let idx = plans.firstIndex(of: plan) {
                  plans.remove(at: idx) // Remove the item from its current position
                  plans.insert(plan, at: 0) // Insert it at the front (index 0)
               }
            }) {
               Text("Start Workout")
                  .foregroundStyle(.white)
                  .font(.title2)
                  .frame(width: 200, height: 50) // Adjust size as needed
                  .background(
                     RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue) // Customize the button color
                  )
            }
            .padding()
         }
         .navigationTitle(plan.name)
         .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
               NavigationLink(destination: ModifyPlanView(plans: $plans, planToEdit: plan)) {
                  Text("Edit")
               }
            }
         }
      }
   }
}
