//
//  WorkoutItemView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/27/23.
//

import SwiftUI

struct PlanInfoListItem: View {
   @Binding var planList: [PlanInfo]
   let plan: PlanInfo

   var body: some View {
      HStack {
         Image(systemName: "square.fill")
         VStack(alignment: .leading) {
            Text(plan.name)
               .font(.title2)
            Text(plan.description)
               .font(.subheadline)
         }
      }
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
         if plan == planList.first {
            Button {
               // start workout
            } label: {
               Image(systemName: "play.fill")
            }
            .tint(.blue)
            Button {
               // workout completed, move to end
               planList.remove(at: 0)
               planList.append(plan)
            } label: {
               Image(systemName: "checkmark.circle.fill")
            }
         } else {
            Button {
               // move plan to next
               if let index = planList.firstIndex(of: plan) {
                  planList.remove(at: index)
                  planList.insert(plan, at: 1)
               }
            } label: {
               Image(systemName: "text.line.first.and.arrowtriangle.forward")
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
