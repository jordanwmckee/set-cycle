//import SwiftUI
//
//struct Miniplayer: View {
//   
//   @ObservedObject var planViewModel: PlanViewModel
//   @Binding var plan: Plan
//   
//   var animation: Namespace.ID
//   @Binding var expand: Bool
//   
//   var height = UIScreen.main.bounds.height / 3
//   var width = UIScreen.main.bounds.width - 20
//   
//   // gesture offset
//   @State var offset: CGFloat = 0
//
//   var body: some View {
//      
//      VStack {
//         
//         // pill on top to indicate swipable screen
//         Capsule()
//            .fill(.gray)
//            .frame(width: expand ? 40 : 0, height: expand ? 4 : 0)
//            .padding(expand ? 20 : 0)
//         
//         // unexpanded content
//         HStack {
//            
//            if expand { Spacer(minLength: 0) }
//            
//            RoundedRectangle(cornerRadius: 15)
//               .aspectRatio(contentMode: .fill)
//               .frame(width: expand ? height : 55, height: expand ? height : 55)
//            
//            if !expand {
//               VStack(alignment: .leading) {
//
//                  Text(plan.name)
//                     .font(.body)
//                     .fontWeight(.bold)
//                  
//                  if let currentExercise = plan.exercises.first {
//                     Text(currentExercise.name)
//                        .font(.subheadline)
//                  }
//               }
//               .matchedGeometryEffect(id: "Label", in: animation)
//            }
//            
//            Spacer(minLength: 0)
//            
//            if !expand {
//               Button(action: {
//                  // cycle to next exercise
//                  planViewModel.nextExercise(plan: plan)
//               }, label: {
//                  Image(systemName: "forward.fill")
//                     .font(.title2)
//                     .foregroundColor(.primary)
//               })
//            }
//            
//         }
//         .padding(.horizontal)
//
//         // expanded content
//         VStack(spacing: 15) {
//            
//            Spacer(minLength: 0)
//            
//            HStack {
//               
//               if expand {
//                  VStack(alignment: .leading) {
//                        
//                     SlidingTextView(text: $plan.name, font: .systemFont(ofSize: 20, weight: .semibold))
////                     Text(plan.name)
////                        .font (.title3)
////                        .foregroundColor(.primary)
////                        .fontWeight(.bold)
//                     
//                     if let currentExercise = plan.exercises.first {
//                        Text(currentExercise.name)
//                           .font(.subheadline)
//                     }
//                  }
//                  .matchedGeometryEffect(id: "Label", in: animation)
//               }
//               
//               Spacer (minLength: 0)
//               
//               Button(action: {}) {
//                  Image(systemName: "ellipsis.circle")
//                     .font (.title2)
//                     .foregroundStyle(.primary)
//               }
//            }
//            .padding()
//            
//            // Stop Button
//            Button(action: {}) {
//               Image(systemName: "stop.fill")
//                  .font(.largeTitle)
//                  .foregroundStyle(.primary)
//            }
//            .padding()
//            
//            Spacer(minLength: 0)
//            
//            // action buttons at the bottom of expanded view
//            HStack(spacing: 22) {
//               
//               Button(action: {}) {
//                  Image(systemName: "arrow.up.message")
//                     .font(.title2)
//                     .foregroundStyle(.secondary)
//               }
//               
//               Button(action: {}) {
//                  Image(systemName: "airplayaudio")
//                     .font(.title2)
//                     .foregroundStyle(.secondary)
//               }
//               
//               Button(action: {}) {
//                  Image(systemName: "list.bullet")
//                     .font(.title2)
//                     .foregroundStyle(.secondary)
//               }
//            }
//         }
//         .frame(height: expand ? nil : 0)
//         .opacity(expand ? 1 : 0)
//      }
//      .frame(maxHeight: expand ? .infinity : 80)
//      .safeAreaPadding(expand ? 40 : 0)
//      .background (
//         BlurView()
//            .onTapGesture {
//               withAnimation(.spring) { expand = true }
//            }
//      )
//      .clipShape(RoundedRectangle(cornerRadius: expand ? 50 : 20))
//      .offset(y: expand ? 0 : -48)
//      .offset(y: offset)
//      .gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:)))
//      .ignoresSafeArea()
//   }
//   
//   func onChanged(value: DragGesture.Value) {
//      // only allow drag when expanded
//      if value.translation.height > 0 && expand {
//         offset = value.translation.height
//      }
//   }
//   
//   func onEnded(value: DragGesture.Value) {
//      withAnimation(.interactiveSpring(
//         response: 0.5,
//         dampingFraction: 0.95,
//         blendDuration: 0.95)) {
//            // if value is > height /3 then close view
//            if value.translation.height > height {
//               expand = false
//            }
//            
//            offset = 0
//      }
//   }
//}
//
//struct SlidingTextView: View {
//   @Binding var text: String
//   // animation offset
//   @State var offset: CGFloat = 0
//   // text size
//   @State var storedSize: CGSize = .zero
//   
//   var animationSpeed: Double = 0.02
//   var delayTime: Double = 0.8
//   
//   @Environment (\.colorScheme) var scheme
//   
//   // customization
//   var font: UIFont
//   
//   var body: some View {
//      
//      ScrollView(.horizontal, showsIndicators: false) {
//         Text(text)
//            .font(Font(font))
//            .offset(x: offset)
//      }
////      // opacity effect
////      .overlay(content: {
////         HStack{
////            let color: Color = scheme == .dark ? .black : .white
////            LinearGradient (
////               colors: [color, color.opacity (0.7), color.opacity (0.5), color.opacity (0.3)],
////               startPoint: .leading, 
////               endPoint: .trailing
////            )
////            .frame(width: 20)
////            Spacer ()
////         }
////      })
//      .disabled(true)
//      .onAppear() {
//
//         let baseText = text
//         
//         // Adding Spacing For Continous Text
//         (1...15).forEach { _ in
//            text.append(" ")
//         }
//         storedSize = textSize()
//         text.append(baseText)
//         
//         let timing: Double = (animationSpeed * storedSize.width)
//         
//         // Delaying FIrst Animation
//         DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//            withAnimation(.linear(duration: timing)){
//               offset = -storedSize.width
//            }
//         }
//      }
//      .onReceive(
//         Timer.publish(every: ((animationSpeed * storedSize.width) + delayTime),
//         on: .main,
//         in: .default).autoconnect()
//      ) { _ in
//         // Resetting offset to 0 to look like its looping
//         offset = 0
//         withAnimation(.linear(duration: (animationSpeed * storedSize.width))) {
//            offset = -storedSize.width
//         }
//      }
//   }
//   
//   func textSize() -> CGSize {
//      let attributes = [NSAttributedString.Key.font: font]
//      let size = (text as NSString).size(withAttributes: attributes)
//      return size
//   }
//}
