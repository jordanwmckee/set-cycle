import SwiftUI

struct SlidingTextView: View {
   @State var text: String
   // animation offset
   @State var offset: CGFloat = 0
   // text size
   @State var storedSize: CGSize = .zero
   
   var animationSpeed: Double = 0.02
   var delayTime: Double = 0.8
   
   @Environment (\.colorScheme) var scheme
   
   // customization
   var font: UIFont
   
   var body: some View {
      
      ScrollView(.horizontal, showsIndicators: false) {
         Text(text)
            .font(Font(font))
            .offset(x: offset)
      }
      //      // opacity effect
      //      .overlay(content: {
      //         HStack{
      //            let color: Color = scheme == .dark ? .black : .white
      //            LinearGradient (
      //               colors: [color, color.opacity (0.7), color.opacity (0.5), color.opacity (0.3)],
      //               startPoint: .leading,
      //               endPoint: .trailing
      //            )
      //            .frame(width: 20)
      //            Spacer ()
      //         }
      //      })
      .disabled(true)
      .onAppear() {
         
         let baseText = text
         
         // Adding Spacing For Continous Text
         (1...15).forEach { _ in
            text.append(" ")
         }
         storedSize = textSize()
         text.append(baseText)
         
         let timing: Double = (animationSpeed * storedSize.width)
         
         // Delaying FIrst Animation
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.linear(duration: timing)){
               offset = -storedSize.width
            }
         }
      }
      .onReceive(
         Timer.publish(every: ((animationSpeed * storedSize.width) + delayTime),
                       on: .main,
                       in: .default).autoconnect()
      ) { _ in
         // Resetting offset to 0 to look like its looping
         offset = 0
         withAnimation(.linear(duration: (animationSpeed * storedSize.width))) {
            offset = -storedSize.width
         }
      }
   }
   
   func textSize() -> CGSize {
      let attributes = [NSAttributedString.Key.font: font]
      let size = (text as NSString).size(withAttributes: attributes)
      return size
   }
}
