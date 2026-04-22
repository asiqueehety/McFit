 //
 //  FitnessDataService.swift
 //  McFit
 //
 //  Created by asiqueehety on 21/3/26.
 //

 import Foundation
 import FirebaseFirestore

 class FitnessDataService: ObservableObject {
     @Published var foodEntries: [FoodEntry] = []
     @Published var exerciseEntries: [ExerciseEntry] = []
     @Published var weightEntries: [WeightEntry] = []
     @Published var dailyStats: DailyStats?
     @Published var isLoading = false
     @Published var errorMessage: String?
    
     private let db = Firestore.firestore()
     private var userId: String?
    
     init(userId: String? = nil) {
         self.userId = userId
     }
    
     func setUserId(_ userId: String) {
         self.userId = userId
         fetchTodayData()
     }
    
     // MARK: - Food Logging
    
     func addFoodEntry(foodName: String, calories: Int, protein: Double, carbs: Double, fat: Double, quantity: Double, unit: String) {
         guard let userId = userId else { return }
        
         isLoading = true
         let foodEntry = FoodEntry(
             id: UUID().uuidString,
             userId: userId,
             foodName: foodName,
             calories: calories,
             protein: protein,
             carbs: carbs,
             fat: fat,
             quantity: quantity,
             unit: unit,
             date: Date(),
             createdAt: Date()
         )
        
         let encoder = JSONEncoder()
         if let encodedData = try? encoder.encode(foodEntry),
            let json = try? JSONSerialization.jsonObject(with: encodedData) as? [String: Any] {
             db.collection("users").document(userId).collection("foodEntries").document(foodEntry.id).setData(json) { [weak self] error in
                 if let error = error {
                     self?.errorMessage = error.localizedDescription
                 } else {
                     self?.foodEntries.append(foodEntry)
                     self?.updateDailyStats()
                 }
                 self?.isLoading = false
             }
         }
     }
    
     func fetchFoodEntriesToday() {
             guard let userId = userId else { return }
             
             let calendar = Calendar.current
             let startOfDay = calendar.startOfDay(for: Date())
             let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
             
             // CONVERSION FIX: Match the Double format that JSONEncoder used to save the dates
             let startOfDayDouble = startOfDay.timeIntervalSinceReferenceDate
             let endOfDayDouble = endOfDay.timeIntervalSinceReferenceDate
             
             db.collection("users").document(userId).collection("foodEntries")
                 .whereField("date", isGreaterThanOrEqualTo: startOfDayDouble)
                 .whereField("date", isLessThan: endOfDayDouble)
                 .order(by: "date", descending: true)
                 .getDocuments { [weak self] snapshot, error in
                     if let error = error {
                         self?.errorMessage = error.localizedDescription
                         return
                     }
                     
                     self?.foodEntries = snapshot?.documents.compactMap { doc in
                         let decoder = JSONDecoder()
                         let jsonData = try? JSONSerialization.data(withJSONObject: doc.data())
                         return jsonData.flatMap { try? decoder.decode(FoodEntry.self, from: $0) }
                     } ?? []
                     
                     self?.updateDailyStats()
                 }
         }
     
     // MARK: - Exercise Logging
    
     func addExerciseEntry(exerciseName: String, duration: Int, caloriesBurned: Int, intensity: String) {
         guard let userId = userId else { return }
        
         isLoading = true
         let exerciseEntry = ExerciseEntry(
             id: UUID().uuidString,
             userId: userId,
             exerciseName: exerciseName,
             duration: duration,
             caloriesBurned: caloriesBurned,
             intensity: intensity,
             date: Date(),
             createdAt: Date()
         )
        
         let encoder = JSONEncoder()
         if let encodedData = try? encoder.encode(exerciseEntry),
            let json = try? JSONSerialization.jsonObject(with: encodedData) as? [String: Any] {
             db.collection("users").document(userId).collection("exerciseEntries").document(exerciseEntry.id).setData(json) { [weak self] error in
                 if let error = error {
                     self?.errorMessage = error.localizedDescription
                 } else {
                     self?.exerciseEntries.append(exerciseEntry)
                     self?.updateDailyStats()
                 }
                 self?.isLoading = false
             }
         }
     }
     
     func fetchExerciseEntriesToday() {
             guard let userId = userId else { return }
             
             let calendar = Calendar.current
             let startOfDay = calendar.startOfDay(for: Date())
             let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
             
             // CONVERSION FIX: Match the Double format that JSONEncoder used to save the dates
             let startOfDayDouble = startOfDay.timeIntervalSinceReferenceDate
             let endOfDayDouble = endOfDay.timeIntervalSinceReferenceDate
             
             db.collection("users").document(userId).collection("exerciseEntries")
                 .whereField("date", isGreaterThanOrEqualTo: startOfDayDouble)
                 .whereField("date", isLessThan: endOfDayDouble)
                 .order(by: "date", descending: true)
                 .getDocuments { [weak self] snapshot, error in
                     if let error = error {
                         self?.errorMessage = error.localizedDescription
                         return
                     }
                     
                     self?.exerciseEntries = snapshot?.documents.compactMap { doc in
                         let decoder = JSONDecoder()
                         let jsonData = try? JSONSerialization.data(withJSONObject: doc.data())
                         return jsonData.flatMap { try? decoder.decode(ExerciseEntry.self, from: $0) }
                     } ?? []
                     
                     self?.updateDailyStats()
                 }
         }
    
     // MARK: - Weight Tracking
    
     func addWeightEntry(weight: Double) {
         guard let userId = userId else { return }
        
         isLoading = true
         let weightEntry = WeightEntry(
             id: UUID().uuidString,
             userId: userId,
             weight: weight,
             date: Date(),
             createdAt: Date()
         )
        
         let encoder = JSONEncoder()
         if let encodedData = try? encoder.encode(weightEntry),
            let json = try? JSONSerialization.jsonObject(with: encodedData) as? [String: Any] {
             db.collection("users").document(userId).collection("weightEntries").document(weightEntry.id).setData(json) { [weak self] error in
                 if let error = error {
                     self?.errorMessage = error.localizedDescription
                 } else {
                     self?.weightEntries.append(weightEntry)
                 }
                 self?.isLoading = false
             }
         }
     }
    
     // MARK: - Daily Stats
    
     func fetchTodayData() {
         fetchFoodEntriesToday()
         fetchExerciseEntriesToday()
     }
    
     private func updateDailyStats() {
         let totalCaloriesConsumed = foodEntries.reduce(0) { $0 + $1.totalCalories }
         let totalCaloriesBurned = exerciseEntries.reduce(0) { $0 + $1.caloriesBurned }
         let totalProtein = foodEntries.reduce(0) { $0 + $1.protein }
         let totalCarbs = foodEntries.reduce(0) { $0 + $1.carbs }
         let totalFat = foodEntries.reduce(0) { $0 + $1.fat }
        
         dailyStats = DailyStats(
             date: Date(),
             caloriesConsumed: totalCaloriesConsumed,
             caloriesBurned: totalCaloriesBurned,
             protein: totalProtein,
             carbs: totalCarbs,
             fat: totalFat,
             waterIntake: 0
         )
     }
 }
