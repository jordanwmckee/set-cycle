import SwiftUI

// MARK: - Library View
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
                     NavigationLink(destination: PlanInfoView(planViewModel: planViewModel, currentPlan: $planViewModel.plans.first!)) {
                        PlanListItem(planViewModel: planViewModel, currentPlan: firstPlan)
                     }
                  }
                  
                  // Second Section: "Up Next" for the rest of the elements
                  Section(header: Text("Up Next")) {
                     ForEach(planViewModel.plans.indices, id: \.self) { index in
                        if index > 0 {
                           NavigationLink(destination: PlanInfoView(planViewModel: planViewModel, currentPlan: $planViewModel.plans[index])) {
                              PlanListItem(planViewModel: planViewModel, currentPlan: planViewModel.plans[index])
                           }
                        }
                     }
                     .onMove(perform: moveItem)
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
   
   func moveItem(from source: IndexSet, to destination: Int) {
      // get the moved item
      var movedItem = planViewModel.plans[source.first!]
      movedItem.position = destination == 1 ? 2 : destination // weird behavior - when dragging to first pos in list, dest is 1, else its dest + 1
      
      planViewModel.plans.move(fromOffsets: source, toOffset: destination)
      // update the position of the item in db
      planViewModel.updatePositions()
      planViewModel.modifyPlan(plan: movedItem, modifyPlanID: movedItem.id)
   }
}

// MARK: - Plan List Item
struct PlanListItem: View {
   @ObservedObject var planViewModel: PlanViewModel
   let currentPlan: Plan
   let maxDescLen = 30
   
   var body: some View {
      
      HStack {
//       Image(systemName: "square.fill") // Plan Image goes here
         VStack(alignment: .leading) {
            Text(currentPlan.name)
               .font(.title2)
            
            Text(
               currentPlan.description.count > maxDescLen
               ? currentPlan.description.prefix(maxDescLen) + "..."
               : currentPlan.description
            )
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
      .swipeActions(edge: .trailing, allowsFullSwipe: false) {
         Button(role: .destructive) {
            planViewModel.deletePlan(plan: currentPlan)
         } label: {
            Label("Delete", systemImage: "trash")
         }
      }
   }
}

