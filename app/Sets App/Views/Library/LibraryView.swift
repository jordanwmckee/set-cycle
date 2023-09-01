import SwiftUI

struct LibraryView: View {
   @Binding var dummyData: [Plan]
   
   var body: some View {
      
      NavigationStack {
         
         VStack {
            
            // Display all existing workouts
            if let firstPlan = dummyData.first {

               List {
                  
                  // First Section: "Current Plan" for the first element
                  Section(header: Text("Current Plan")) {
                     
                     NavigationLink(destination: PlanInfoView(plan: firstPlan, plans: $dummyData)) {
                        PlanListItem(plans: $dummyData, plan: firstPlan)
                           .listRowSeparator(.hidden)
                     }
                  }
                  
                  // Second Section: "Up Next" for the rest of the elements
                  Section(header: Text("Up Next")) {
                     
                     ForEach(dummyData.dropFirst()) { plan in
                        
                        NavigationLink(destination: PlanInfoView(plan: plan, plans: $dummyData)) {
                           PlanListItem(plans: $dummyData, plan: plan)
                              .listRowSeparator(.hidden)
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
               NavigationLink(destination: ModifyPlanView(plans: $dummyData)) {
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

