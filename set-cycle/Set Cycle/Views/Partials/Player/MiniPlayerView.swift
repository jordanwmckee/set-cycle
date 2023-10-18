import SwiftUI

struct Miniplayer: View {
   
   @ObservedObject var planViewModel: PlanViewModel
   @Binding var plan: Plan
   
   // for presenting popover
   @State var isEditingReps = false
   @State var repToEdit: Rep = Rep(id: 0, weight: 0, reps: 0)
   
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
            .padding(.top, expand ? 20 : 0)
         
         // MARK: - Unexpanded Content
         HStack {

            if !expand {
               VStack(alignment: .leading) {
                  
//                  SlidingTextView(text: plan.name, font: .systemFont(ofSize: 20, weight: .semibold))
                  Text(plan.name)
                     .font(.title3)
                     .fontWeight(.semibold)
                  
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
         
         // MARK: - Expanded Content
         VStack {
            
            if expand {
               VStack {
//               SlidingTextView(text: plan.name, font: .systemFont(ofSize: 24, weight: .semibold))
                  Text(plan.name)
                     .foregroundStyle(.secondary)
                  
                  if let currentExercise = plan.exercises.first {
                     Text(currentExercise.name)
                        .font(.title)
                        .fontWeight(.bold)
                  }
               }
               .padding(.vertical)
               .matchedGeometryEffect(id: "Label", in: animation)
               
               Spacer(minLength: 0)
            }
            
            // view current exercise
            ZStack(alignment: .center) {
               RoundedRectangle(cornerRadius: 15)
                  .frame(width: height, height: height)
               
               Text("Youtube video here")
                  .foregroundStyle(.black)
            }
            .padding(.vertical)
            
            // MARK: - Current Exercise Info
            if expand {
               if let currentExercise = plan.exercises.first {
                  ScrollView {
                     ForEach(currentExercise.reps.indices, id: \.self) { index in
                        HStack {
                           Text(String(currentExercise.reps[index].weight) + " lbs.")
                              .font(.title2)
                           Spacer()
                           Text(String(currentExercise.reps[index].reps) + " reps.")
                              .font(.title2)
                        }
                        .padding(.top)
                        .onTapGesture {
                           repToEdit = currentExercise.reps[index]
                           isEditingReps.toggle()
                        }
                        
                        Divider()
                     }
                  }
                  .scrollIndicators(.hidden)
               }
            }
            
            Spacer(minLength: 0)
            
            // MARK: - Control Buttons
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
                        
            // MARK: - Action Buttons
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
      .sheet(isPresented: $isEditingReps) {
         EditRepsView(
            editedRep: $repToEdit,
            onSave: { newWeight, newReps in
               // update data model
               repToEdit.weight = Int(newWeight) ?? 0
               repToEdit.reps = Int(newReps) ?? 0
               isEditingReps = false
            }
         )
         .presentationDetents([.height(200)])
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

struct EditRepsView: View {
   @Binding var editedRep: Rep
   var onSave: (String, String) -> Void
   
   @FocusState private var isWeightFieldFocused: Bool
   @FocusState private var isRepsFieldFocused: Bool
   
   @State private var editedWeight: String = ""
   @State private var editedReps: String = ""
   
   init(editedRep: Binding<Rep>, onSave: @escaping (String, String) -> Void) {
      _editedRep = editedRep
      self.onSave = onSave
   }
   
   var body: some View {
      NavigationStack {
         VStack {
            HStack {
               Text("Weight: ")
                  .font(.largeTitle)
               
               Spacer()
               
               TextField("", text: $editedWeight)
                  .font(.largeTitle)
                  .focused($isWeightFieldFocused)
                  .onAppear {
                     // Initialize the editedWeight when the view appears
                     editedWeight = String(editedRep.weight)
                     isWeightFieldFocused = true // Auto-focus the weight field
                  }
                  .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                     if let textField = obj.object as? UITextField {
                        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                     }
                  }
            }
            .onTapGesture {
               isWeightFieldFocused = true
            }
            
            HStack {
               Text("Reps:")
                  .font(.largeTitle)
               
               Spacer()
               
               TextField("", text: $editedReps)
                  .font(.largeTitle)
                  .focused($isRepsFieldFocused)
                  .onAppear {
                     // Initialize the editedReps when the view appears
                     editedReps = String(editedRep.reps)
                  }
                  .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                     if let textField = obj.object as? UITextField {
                        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                     }
                  }
            }
            .onTapGesture {
               isRepsFieldFocused = true
            }
         }
      }
      .padding()
      .navigationTitle("Edit Rep")
      .navigationBarTitleDisplayMode(.inline)
      .keyboardType(.numberPad)
      .toolbar {
         ToolbarItem(placement: .keyboard) {
            HStack {
               Spacer()
               Button("Done") {
                  // Handle the "Done" button action here
                  UIApplication.shared.endEditing() // Close the keyboard
               }
            }
         }
      }
   }
}

extension UIApplication {
   func endEditing() {
      sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}
