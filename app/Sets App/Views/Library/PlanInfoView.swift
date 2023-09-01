import SwiftUI

struct PlanInfoView: View {
   @ObservedObject var planViewModel: PlanViewModel
   let currentPlan: Plan
   
   var body: some View {
      
      NavigationStack {
         
         VStack {

            Text(currentPlan.description)
               .font(.subheadline)
               .padding(.bottom)
            
            // Exercise overview
            if !currentPlan.exercises.isEmpty {
               
               List(currentPlan.exercises, id: \.self) { exercise in
                  
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
               
               planViewModel.startPlan(plan: currentPlan)
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
         .navigationTitle(currentPlan.name)
         .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
               NavigationLink(destination: ModifyPlanView(planViewModel: planViewModel, planToEdit: currentPlan)) {
                  Text("Edit")
               }
            }
         }
      }
   }
}
