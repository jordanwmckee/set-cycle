//
//  LibraryView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/27/23.
//

import SwiftUI

struct LibraryView: View {
   @State private var dummyData: [PlanInfo] = [PlanInfo(name: "day1", description: "desc for day 1", exercises: nil), PlanInfo(name: "day2", description: "desc for day 2", exercises: nil), PlanInfo(name: "day4", description: "desc for day 4", exercises: nil), PlanInfo(name: "day5", description: "desc for day 5", exercises: nil), PlanInfo(name: "day6", description: "desc for day 6", exercises: nil), PlanInfo(name: "day7", description: "desc for day 7", exercises: nil)]
   @State private var selectedPlan: PlanInfo? = nil
   @State private var searchText: String = ""
   @State private var isEditing = false
   
   // Function to filter the array based on searchText
   func filterPlans() -> [PlanInfo] {
      if searchText.isEmpty {
         return dummyData // nothing is entered in search bar
      } else {
         return dummyData.filter { plan in
            plan.name.localizedCaseInsensitiveContains(searchText)
         }
      }
   }
   
   var body: some View {
      NavigationStack {
         VStack {
            SearchBar(placeholder: "Search", text: $searchText)
               .padding(.horizontal)
                              
               // Display all existing workouts
            List {
               // First Section: "Current Plan" for the first element
               Section(header: Text("Current Plan")) {
                  if let firstPlan = filterPlans().first {
                     PlanInfoListItem(planList: $dummyData, plan: firstPlan)
                        .listRowSeparator(.hidden)
                  }
               }
               
               // Second Section: "Up Next" for the rest of the elements
               Section(header: Text("Up Next")) {
                  ForEach(filterPlans().dropFirst()) { plan in
                     PlanInfoListItem(planList: $dummyData, plan: plan)
                        .listRowSeparator(.hidden)
                  }
               }
            }
            .listStyle(.plain)
         }
         // Create toolbar
         .navigationTitle("Plans")
         .toolbar {
            ToolbarItem(placement: .topBarLeading) {
               Button(action: {
                  isEditing.toggle()
               }) {
                  Text("Edit")
               }
            }
            ToolbarItem(placement: .topBarTrailing) {
               NavigationLink(destination: CreateWorkoutView()) {
                  Image(systemName: "plus.circle.fill")
               }
            }
         }
         .sheet(item: $selectedPlan) { plan in
            PlanInfoSheet(plan: plan)
//               .presentationDetents([.medium, .large])
         }
      }
   }
}
