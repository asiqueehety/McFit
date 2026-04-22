//
//  HomeTabView.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI

struct HomeTabView: View {
    let user: User?
    @ObservedObject var fitnessDataService: FitnessDataService
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Welcome Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello, \(user?.displayName ?? "User")!")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(formattedDate())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Calorie Summary
                    if let stats = fitnessDataService.dailyStats {
                        VStack(spacing: 16) {
                            // Main Calorie Card
                            VStack(spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Daily Calorie Goal")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(user?.dailyCalorieGoal ?? 2000)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Remaining")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(max(0, (user?.dailyCalorieGoal ?? 2000) - stats.caloriesConsumed + stats.caloriesBurned))")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                CalorieProgressView(
                                    consumed: stats.caloriesConsumed,
                                    burned: stats.caloriesBurned,
                                    goal: user?.dailyCalorieGoal ?? 2000
                                )
                            }
                            .padding(16)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                            
                            // Stats Grid
                            HStack(spacing: 12) {
                                StatCard(
                                    title: "Consumed",
                                    value: "\(stats.caloriesConsumed)",
                                    unit: "kcal",
                                    color: .orange
                                )
                                StatCard(
                                    title: "Burned",
                                    value: "\(stats.caloriesBurned)",
                                    unit: "kcal",
                                    color: .red
                                )
                            }
                            
                            // Macros
                            HStack(spacing: 12) {
                                MacroCard(
                                    name: "Protein",
                                    value: String(format: "%.1f", stats.protein),
                                    unit: "g",
                                    color: .red
                                )
                                MacroCard(
                                    name: "Carbs",
                                    value: String(format: "%.1f", stats.carbs),
                                    unit: "g",
                                    color: .blue
                                )
                                MacroCard(
                                    name: "Fat",
                                    value: String(format: "%.1f", stats.fat),
                                    unit: "g",
                                    color: .yellow
                                )
                            }
                        }
                    }
                    
                    // User Info Card
                    if let user = user {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Your Stats")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            
                            HStack(spacing: 16) {
                                InfoItem(label: "BMI", value: String(format: "%.1f", user.bmi))
                                InfoItem(label: "Weight", value: String(format: "%.1f", user.weight) + " kg")
                                InfoItem(label: "Height", value: String(format: "%.0f", user.height) + " cm")
                            }
                        }
                        .padding(16)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding(16)
            }
            .navigationTitle("McFit")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            fitnessDataService.fetchTodayData()
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: Date())
    }
}

struct CalorieProgressView: View {
    let consumed: Int
    let burned: Int
    let goal: Int
    
    var progress: Double {
        let net = consumed - burned
        return Double(net) / Double(goal)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            SwiftUI.ProgressView(value: min(progress, 1.0))
                .tint(.blue)
            
            HStack {
                Text("Net: \(consumed - burned) kcal")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct MacroCard: View {
    let name: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(name)
                .font(.caption2)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct InfoItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeTabView(user: nil, fitnessDataService: FitnessDataService())
}
