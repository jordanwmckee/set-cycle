//
//  WorkoutDetailsView.swift
//  Sets App
//
//  Created by Jordan McKee on 8/27/23.
//

import SwiftUI

struct PlanInfoSheet: View {
   let plan: PlanInfo
   
   var body: some View {
      VStack {
         Text(plan.name)
            .font(.largeTitle)
         Text(plan.description)
      }
   }
}
