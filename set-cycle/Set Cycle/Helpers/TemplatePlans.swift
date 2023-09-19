//import Foundation
//
//// Define exercises
//let exercise1 = Exercise(id: 1, name: "Squat", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 100, reps: 10), Rep(weight: 100, reps: 10), Rep(weight: 100, reps: 10)])
//let exercise2 = Exercise(id: 2, name: "Bench Press", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 80, reps: 8), Rep(weight: 100, reps: 10), Rep(weight: 100, reps: 10), Rep(weight: 100, reps: 10), Rep(weight: 100, reps: 10)])
//let exercise3 = Exercise(id: 3, name: "Deadlift", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 120, reps: 6)])
//let exercise4 = Exercise(id: 4, name: "Pull-Ups", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise5 = Exercise(id: 5, name: "Push-Ups", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//
//// Define plans
//let plan1 = Plan(
//   id: 1,
//   name: "Full-Body Strength Training",
//   description: "A comprehensive full-body workout plan to build strength and muscle.",
//   exercises: [exercise1, exercise2, exercise3, exercise4, exercise5]
//)
//
//let exercise6 = Exercise(id: 1, name: "Running", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise7 = Exercise(id: 2, name: "Plank", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise8 = Exercise(id: 3, name: "Burpees", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise9 = Exercise(id: 4, name: "Jumping Jacks", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise10 = Exercise(id: 5, name: "Mountain Climbers", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//
//let plan2 = Plan(
//   id: 2,
//   name: "Cardio and Core Workout",
//   description: "A high-intensity cardio and core workout for improving endurance and core strength.",
//   exercises: [exercise6, exercise7, exercise8, exercise9, exercise10]
//)
//
//let exercise11 = Exercise(id: 1, name: "Dumbbell Rows", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 35, reps: 12)])
//let exercise12 = Exercise(id: 2, name: "Push-Ups", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise13 = Exercise(id: 3, name: "Dumbbell Bench Press", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 40, reps: 10)])
//let exercise14 = Exercise(id: 4, name: "Pull-Ups", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise15 = Exercise(id: 5, name: "Lateral Raises", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 15, reps: 12)])
//
//let plan3 = Plan(
//   id: 3,
//   name: "Upper Body Hypertrophy",
//   description: "Focus on building muscle in your upper body with this hypertrophy workout plan.",
//   exercises: [exercise11, exercise12, exercise13, exercise14, exercise15]
//)
//
//let exercise16 = Exercise(id: 1, name: "Leg Press", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 200, reps: 10)])
//let exercise17 = Exercise(id: 2, name: "Lunges", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise18 = Exercise(id: 3, name: "Calf Raises", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 50, reps: 15)])
//let exercise19 = Exercise(id: 4, name: "Squats", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 95, reps: 8)])
//let exercise20 = Exercise(id: 5, name: "Hamstring Curls", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 40, reps: 10)])
//
//let plan4 = Plan(
//   id: 4,
//   name: "Leg Day for Strength",
//   description: "A leg-focused workout plan designed to increase leg strength and power.",
//   exercises: [exercise16, exercise17, exercise18, exercise19, exercise20]
//)
//
//// Define exercises for Plan 5
//let exercise26 = Exercise(name: "Seated Leg Raise", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 20, reps: 15)])
//let exercise27 = Exercise(name: "Russian Twists", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 0, reps: 20)])
//let exercise28 = Exercise(name: "Bicycle Crunches", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 0, reps: 20)])
//let exercise29 = Exercise(name: "Plank Leg Raises", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 0, reps: 15)])
//let exercise30 = Exercise(name: "Side Planks", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 0, reps: 20)])
//
//// Define Plan 5
//let plan5 = Plan(
//   name: "Core and Abs Workout",
//   description: "Strengthen your core and sculpt your abs with this workout plan.",
//   exercises: [exercise26, exercise27, exercise28, exercise29, exercise30]
//)
//
//// Define exercises for Plan 6
//let exercise31 = Exercise(name: "Dumbbell Squats", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 40, reps: 12)])
//let exercise32 = Exercise(name: "Lat Pulldowns", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 70, reps: 10)])
//let exercise33 = Exercise(name: "Leg Curls", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 50, reps: 12)])
//let exercise34 = Exercise(name: "Bicep Curls", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 25, reps: 10)])
//let exercise35 = Exercise(name: "Tricep Dips", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 0, reps: 15)])
//
//// Define Plan 6
//let plan6 = Plan(
//   name: "Full-Body Hypertrophy",
//   description: "A high-intensity full-body workout plan for muscle hypertrophy.",
//   exercises: [exercise31, exercise32, exercise33, exercise34, exercise35]
//)
//
//// Define exercises for Plan 7
//let exercise36 = Exercise(name: "Box Jumps", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise37 = Exercise(name: "Kettlebell Swings", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 20, reps: 15)])
//let exercise38 = Exercise(name: "Battle Ropes", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//let exercise39 = Exercise(name: "Medicine Ball Slams", video: "https://www.youtube.com/watch?v=XXX", reps: [Rep(weight: 15, reps: 20)])
//let exercise40 = Exercise(name: "Sled Pushes", video: "https://www.youtube.com/watch?v=XXX", reps: [])
//
//// Define Plan 7
//let plan7 = Plan(
//   name: "High-Intensity Interval Training (HIIT)",
//   description: "A high-intensity interval training plan for cardiovascular fitness and endurance.",
//   exercises: [exercise36, exercise37, exercise38, exercise39, exercise40]
//)
//
//// Create an array of all plan templates
//let templates = [plan1, plan2, plan3, plan4, plan5, plan6, plan7]
