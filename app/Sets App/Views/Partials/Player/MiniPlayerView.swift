import SwiftUI

struct Miniplayer: View {
   
   @ObservedObject var planViewModel: PlanViewModel
   @Binding var plan: Plan
   
   var animation: Namespace.ID
   @Binding var expand: Bool
   
   var height = UIScreen.main.bounds.height / 3
   var width = UIScreen.main.bounds.width - 20
   
   // gesture offset
   @State var offset: CGFloat = 0
   
   var body: some View {
      
      VStack {
         
         // pill on top to indicate swipable screen
         Capsule()
            .fill(.gray)
            .frame(width: expand ? 40 : 0, height: expand ? 4 : 0)
            .padding(expand ? 20 : 0)
         
         // unexpanded content
         HStack {

            if !expand {
               VStack(alignment: .leading) {
                  
//                  SlidingTextView(text: plan.name, font: .systemFont(ofSize: 20, weight: .semibold))
                  Text(plan.name)
                     .font(.title3)
                     .fontWeight(.bold)
                  
                  if let currentExercise = plan.exercises.first {
                     Text(currentExercise.name)
                        .font(.subheadline)
                  }
               }
               .padding(.trailing)
               .matchedGeometryEffect(id: "Label", in: animation)
            }
            
            Spacer(minLength: 0)
            
            if !expand {
               Button(action: {
                  // cycle to next exercise
                  planViewModel.nextExercise(plan: plan)
               }, label: {
                  Image(systemName: "forward.fill")
                     .font(.title2)
                     .foregroundColor(.primary)
               })
            }
            
         }
         .padding(.horizontal)
         
         // expanded content
         VStack(spacing: 15) {
            
            if expand {
               VStack {
                  
//               SlidingTextView(text: plan.name, font: .systemFont(ofSize: 24, weight: .semibold))
                  // Label
                  Text(plan.name)
                     .font(.title2)
                     .fontWeight(.semibold)
                  
                  if let currentExercise = plan.exercises.first {
                     Text(currentExercise.name)
                        .font(.title3)
                  }
               }
               .matchedGeometryEffect(id: "Label", in: animation)
            }
            
            // view current exercise
            ZStack(alignment: .center) {
               RoundedRectangle(cornerRadius: 15)
                  .frame(width: height, height: height)
               
               Text("Youtube video here")
                  .foregroundStyle(.black)
            }
            
            if let currentExercise = plan.exercises.first {
               ScrollView {
                  ForEach(currentExercise.reps.indices, id: \.self) { index in
                     HStack {
                        Text(String(currentExercise.reps[index].weight) + " lbs.")
                        Spacer()
                        Text(String(currentExercise.reps[index].reps) + " reps.")
                     }
                     .padding(.top)
                     
                     Divider()
                  }
               }
               .scrollIndicators(.hidden)
            }
            
            Spacer(minLength: 0)
            
            // control buttons
            HStack {
               // Prev Button
               Button(action: {
                  planViewModel.previousExercise(plan: plan)
               }) {
                  Image(systemName: "backward.fill")
                     .font(.title)
                     .foregroundStyle(.primary)
               }
               .padding()
               
               Spacer()
               
               Button(action: {
                  planViewModel.completePlan()
                  withAnimation(.spring) { expand = false }
               }) {
                  Text("Complete")
               }
               
               Spacer()
               
               // Next Button
               Button(action: {
                  planViewModel.nextExercise(plan: plan)
               }) {
                  Image(systemName: "forward.fill")
                     .font(.title)
                     .foregroundStyle(.primary)
               }
               .padding()
            }
            .padding(.bottom)
                        
            // action buttons at the bottom of expanded view
            HStack(spacing: 22) {
               
               Button(action: {}) {
                  Image(systemName: "arrow.up.message")
                     .font(.title2)
                     .foregroundStyle(.secondary)
               }
               
               Button(action: {}) {
                  Image(systemName: "airplayaudio")
                     .font(.title2)
                     .foregroundStyle(.secondary)
               }
               
               Button(action: {}) {
                  Image(systemName: "list.bullet")
                     .font(.title2)
                     .foregroundStyle(.secondary)
               }
            }
         }
         .frame(height: expand ? nil : 0)
         .opacity(expand ? 1 : 0)
      }
      .frame(maxHeight: expand ? .infinity : 80)
      .safeAreaPadding(expand ? 40 : 0)
      .background (
         BlurView()
            .onTapGesture {
               withAnimation(.spring) { expand = true }
            }
      )
      .clipShape(RoundedRectangle(cornerRadius: expand ? 50 : 20))
      .offset(y: expand ? 0 : -48)
      .offset(y: offset)
      .gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:)))
      .ignoresSafeArea()
   }
   
   func onChanged(value: DragGesture.Value) {
      // only allow drag when expanded
      if value.translation.height > 0 && expand {
         offset = value.translation.height
      }
   }
   
   func onEnded(value: DragGesture.Value) {
      withAnimation(.interactiveSpring(
         response: 0.5,
         dampingFraction: 0.95,
         blendDuration: 0.95)) {
            // if value is > height /3 then close view
            if value.translation.height > height {
               expand = false
            }
            
            offset = 0
         }
   }
}
