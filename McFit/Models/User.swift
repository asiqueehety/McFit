//
//  User.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var email: String
    var displayName: String
    var age: Int
    var weight: Double // in kg
    var height: Double // in cm
    var gender: String // "male" or "female"
    var goal: String // "lose", "gain", "maintain"
    var activityLevel: String // "sedentary", "light", "moderate", "very", "extreme"
    var dailyCalorieGoal: Int
    var createdAt: Date
    
    // Computed property for BMI
    var bmi: Double {
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    // Computed property for BMR (Basal Metabolic Rate) using Mifflin-St Jeor formula
    var bmr: Double {
        if gender.lowercased() == "male" {
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
        } else {
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
        }
    }
}

struct FoodEntry: Codable, Identifiable {
    let id: String
    let userId: String
    var foodName: String
    var calories: Int
    var protein: Double // in grams
    var carbs: Double // in grams
    var fat: Double // in grams
    var quantity: Double
    var unit: String // "g", "ml", "piece", etc.
    var date: Date
    var createdAt: Date
    
    var totalCalories: Int {
        Int(Double(calories) * (quantity / 100))
    }
}

struct ExerciseEntry: Codable, Identifiable {
    let id: String
    let userId: String
    var exerciseName: String
    var duration: Int // in minutes
    var caloriesBurned: Int
    var intensity: String // "light", "moderate", "vigorous"
    var date: Date
    var createdAt: Date
}

struct WeightEntry: Codable, Identifiable {
    let id: String
    let userId: String
    var weight: Double // in kg
    var date: Date
    var createdAt: Date
}

struct DailyStats: Identifiable {
    let id: String = UUID().uuidString
    var date: Date
    var caloriesConsumed: Int
    var caloriesBurned: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var waterIntake: Int // in ml
    
    var calorieRemaining: Int {
        2000 - caloriesConsumed + caloriesBurned
    }
}
