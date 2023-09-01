import SwiftUI

struct Miniplayer: View {
   let plan: Plan
   
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
            
            if expand { Spacer(minLength: 0) }
            
            RoundedRectangle(cornerRadius: 15)
               .aspectRatio(contentMode: .fill)
               .frame(width: expand ? height : 55, height: expand ? height : 55)
            
            if !expand {
               Text(plan.name)
                  .font(.title2)
                  .fontWeight(.bold)
                  .matchedGeometryEffect(id: "Label", in: animation)
            }
            
            Spacer(minLength: 0)
            
            if !expand {
               
               Button(action: {}, label: {
                  Image(systemName: "forward.fill")
                     .font(.title2)
                     .foregroundColor(.primary)
               })
            }
            
         }
         .padding(.horizontal)

         // expanded content
         VStack(spacing: 15) {
            
            Spacer(minLength: 0)
            
            HStack {
               if expand {
                  Text(plan.name)
                     .font (.title2)
                     .foregroundColor(.primary)
                     .fontWeight(.bold)
                     .matchedGeometryEffect(id: "Label", in: animation)
               }
               
               Spacer (minLength: 0)
               
               Button(action: {}) {
                  Image(systemName: "ellipsis.circle")
                     .font (.title2)
                     .foregroundStyle(.primary)
               }
            }
            .padding()
            
            // Stop Button
            Button(action: {}) {
               Image(systemName: "stop.fill")
                  .font(.largeTitle)
                  .foregroundStyle(.primary)
            }
            .padding()
            
            Spacer(minLength: 0)
            
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
      .clipShape(RoundedRectangle(cornerRadius: 20))
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
