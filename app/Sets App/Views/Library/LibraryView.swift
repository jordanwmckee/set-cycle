import SwiftUI

struct LibraryView: View {
   @State private var dummyData: [Plan] = dummyPlans
   @Binding var selectedPlan: Plan?
   
   var body: some View {
      NavigationStack {
         VStack {
            // Display all existing workouts
            List {
               // First Section: "Current Plan" for the first element
               Section(header: Text("Current Plan")) {
                  if let firstPlan = dummyData.first {
                     Button(action: {
                        selectedPlan = firstPlan
                     }) {
                        PlanListItem(plans: $dummyData, plan: firstPlan)
                           .listRowSeparator(.hidden)
                     }
                  }
               }
               
               // Second Section: "Up Next" for the rest of the elements
               Section(header: Text("Up Next")) {
                  ForEach(dummyData.dropFirst()) { plan in
                     Button(action: {
                        selectedPlan = plan
                     }) {
                        PlanListItem(plans: $dummyData, plan: plan)
                           .listRowSeparator(.hidden)
                     }
                  }
               }
            }
            .listStyle(.plain)
         }
         // Create toolbar
         .navigationTitle("Plans")
         .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
               NavigationLink(destination: ModifyPlanView(plans: $dummyData)) {
                  Image(systemName: "plus.circle.fill")
                     .font(.title2)
               }
            }
         }
         .sheet(item: $selectedPlan) { plan in
            PlanInfoSheet(plan: plan, plans: $dummyData)
         }
      }
   }
}

// MARK: - Plan List Item
struct PlanListItem: View {
   @Binding var plans: [Plan]
   let plan: Plan
   
   var body: some View {
      HStack {
//         Image(systemName: "square.fill") // Plan Image goes here
         VStack(alignment: .leading) {
            Text(plan.name)
               .font(.title2)
            Text(plan.description)
               .font(.subheadline)
         }
      }
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
         if plan == plans.first {
            Button {
               // start workout
            } label: {
               Image(systemName: "play.fill")
            }
            .tint(.blue)
            Button {
               // workout completed, move to end
               plans.remove(at: 0)
               plans.append(plan)
            } label: {
               Image(systemName: "checkmark.circle.fill")
            }
         } else {
            Button {
               // move plan to next
               if let index = plans.firstIndex(of: plan) {
                  plans.remove(at: index)
                  plans.insert(plan, at: 1)
               }
            } label: {
               Image(systemName: "text.line.first.and.arrowtriangle.forward")
            }
            .tint(.indigo)
            Button {
               // move plan to end
               if let index = plans.firstIndex(of: plan) {
                  plans.remove(at: index)
                  plans.append(plan)
               }
            } label: {
               Image(systemName: "text.line.last.and.arrowtriangle.forward")
            }
            .tint(.orange)
         }
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: false) {
         Button(role: .destructive) {
            // Action when swiped right
         } label: {
            Label("Delete", systemImage: "trash")
         }
      }
   }
}

