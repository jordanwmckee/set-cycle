import SwiftUI

struct PlanInfoView: View {
   @ObservedObject var planViewModel: PlanViewModel
   @Binding var currentPlan: Plan
   
   var body: some View {
      
      NavigationStack {
         
         VStack {

            Text(currentPlan.name)
               .font(.title)
               .padding(.horizontal)
               .padding(.bottom, 10)
            
            Text(currentPlan.description)
               .font(.subheadline)
               .padding(.bottom)
               .padding(.horizontal)
            
            // Exercise overview
            if !currentPlan.exercises.isEmpty {
               List(currentPlan.exercises, id: \.self) { exercise in
                  
                  Section(header: Text(exercise.name)) {
                     VStack(alignment: .leading) {
                        
                        List(exercise.reps.indices, id: \.self) { idx in
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
               Text("Start")
                  .foregroundStyle(.white)
                  .font(.title2)
                  .frame(width: 300, height: 50) // Adjust size as needed
                  .background(
                     RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue) // Customize the button color
                  )
            }
            .padding()
         }
         .navigationBarTitleDisplayMode(.inline)
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
