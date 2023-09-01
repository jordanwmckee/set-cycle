import SwiftUI

struct ModifyPlanView: View {
   @Binding var plans: [Plan]
   @State private var isViewingTemplates = false
   @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
   // Properties to track user input
   @State private var name: String = ""
   @State private var description: String = ""
   @State private var exercises: [Exercise] = []
   
   // Plan to edit, if provided
   var planToEdit: Plan?
   
   // Initialize the view with a Plan for editing (if any)
   init(plans: Binding<[Plan]>, planToEdit: Plan? = nil) {
      self._plans = plans
      self.planToEdit = planToEdit
      
      if let plan = planToEdit {
         // Prepopulate fields when editing a plan
         _name = State(initialValue: plan.name)
         _description = State(initialValue: plan.description)
         _exercises = State(initialValue: plan.exercises ?? [])
      }
   }
   
   var body: some View {
      NavigationStack {
         Form {
            Section {
               TextField("Name", text: $name)
               TextField("Description", text: $description)
            }
            
            ForEach(exercises.indices, id: \.self) { idx in
               Section {
                  ExerciseRowView(exercise: $exercises[idx], exercises: $exercises)
               }
            }
            
            Button("Add Exercise") {
               // Add an empty exercise when the user taps the "Add Exercise" button
               exercises.append(Exercise(name: "", weight: 0, reps: []))
            }
            
            Section {
               Button("Save") {
                  // Create a new Plan instance with user input
                  let updatedPlan = Plan(
                     name: name,
                     description: description,
                     exercises: exercises.isEmpty ? [] : exercises
                  )
                  
                  if let index = plans.firstIndex(where: { $0.id == planToEdit?.id }) {
                     // If editing, replace the existing plan with the updated one
                     plans[index] = updatedPlan
                  } else {
                     // If creating a new plan, save it
                     plans.append(updatedPlan)
                  }
                  
                  // Optionally, reset the form fields
                  name = ""
                  description = ""
                  exercises = []
                  
                  // dismiss view
                  presentationMode.wrappedValue.dismiss()
               }
            }
         }
         .navigationTitle(planToEdit == nil ? "New Plan" : "Edit Plan")
         .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               if planToEdit == nil {
                  Button("Templates") {
                     isViewingTemplates.toggle()
                  }
               }
            }
         }
         .sheet(isPresented: $isViewingTemplates) {
            Text("Templates")
         }
      }
   }
}

// MARK: - Exercise Row View
struct ExerciseRowView: View {
   @Binding var exercise: Exercise
   @Binding var exercises: [Exercise]
   
   var body: some View {
      TextField("Exercise Name", text: $exercise.name)
      
      // construct sets
      ForEach(exercise.reps.indices, id: \.self) { idx in
         RepRowView(rep: $exercise.reps[idx])
      }
      
      // add new sets
      Button("Add Set") {
         exercise.reps.append(Rep(weight: 0, reps: 0))
      }
      Button("Delete") {
         if let index = exercises.firstIndex(where: { $0.name == exercise.name }) {
            exercises.remove(at: index)
         }
      }
      .foregroundColor(.red)
   }
}

// MARK: - Rep Row View
struct RepRowView: View {
   @Binding var rep: Rep
   
   var body: some View {
      HStack {
         TextField("Weight", value: $rep.weight, formatter: NumberFormatter())
         Spacer()
         Text("lbs.")
         Spacer()
         TextField("Reps", value: $rep.reps, formatter: NumberFormatter())
         Spacer()
         Text("reps")
      }
   }
}
