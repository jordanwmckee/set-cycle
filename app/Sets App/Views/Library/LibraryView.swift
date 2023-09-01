import SwiftUI

struct LibraryView: View {
   @ObservedObject var planViewModel: PlanViewModel
   
   var body: some View {
      
      NavigationStack {
         
         VStack {
            
            // Display all existing workouts
            if let firstPlan = planViewModel.plans.first {
               List {
                  // First Section: "Current Plan" for the first element
                  Section(header: Text("Current Plan")) {
                     NavigationLink(destination: PlanInfoView(planViewModel: planViewModel, currentPlan: firstPlan)) {
                        PlanListItem(planViewModel: planViewModel, currentPlan: firstPlan)
                     }
                  }
                  
                  // Second Section: "Up Next" for the rest of the elements
                  Section(header: Text("Up Next")) {
                     ForEach(planViewModel.plans.dropFirst()) { plan in
                        NavigationLink(destination: PlanInfoView(planViewModel: planViewModel, currentPlan: plan)) {
                           PlanListItem(planViewModel: planViewModel, currentPlan: plan)
                        }
                     }
                  }
               }
               .listStyle(.plain)
            } else {
               Text("No plans found. Tap on the + to create a plan!")
                  .font(.title3)
                  .padding()
            }
         }
         // Create toolbar
         .navigationTitle("Plans")
         .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
               NavigationLink(destination: ModifyPlanView(planViewModel: planViewModel)) {
                  Image(systemName: "plus.circle.fill")
                     .font(.title2)
               }
            }
         }
         Spacer(minLength: 0)
      }
   }
}

// MARK: - Plan List Item
struct PlanListItem: View {
   @ObservedObject var planViewModel: PlanViewModel
   let currentPlan: Plan
   
   var body: some View {
      
      HStack {
         
//         Image(systemName: "square.fill") // Plan Image goes here
         VStack(alignment: .leading) {
   
            Text(currentPlan.name)
               .font(.title2)
            
            Text(currentPlan.description)
               .font(.subheadline)
         }
      }
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
         if currentPlan == planViewModel.plans.first {
            Button {
               // start workout
            } label: {
               Image(systemName: "play.fill")
            }
            .tint(.blue)
            
            Button {
               // workout completed
               planViewModel.completePlan()
            } label: {
               Image(systemName: "checkmark.circle.fill")
            }
         } else {
            Button {
               planViewModel.makePlanNext(plan: currentPlan)
            } label: {
               Image(systemName: "text.line.first.and.arrowtriangle.forward")
            }
            .tint(.indigo)
            
            Button {
               planViewModel.makePlanLast(plan: currentPlan)
            } label: {
               Image(systemName: "text.line.last.and.arrowtriangle.forward")
            }
            .tint(.orange)
         }
      }
      .listRowSeparator(.hidden)
      .swipeActions(edge: .trailing, allowsFullSwipe: false) {
         Button(role: .destructive) {
            planViewModel.deletePlan(plan: currentPlan)
         } label: {
            Label("Delete", systemImage: "trash")
         }
      }
   }
}

