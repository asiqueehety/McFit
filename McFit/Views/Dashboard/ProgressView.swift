//
//  ProgressView.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI

struct ProgressView: View {
    let user: User?
    @ObservedObject var fitnessDataService: FitnessDataService
    @State private var selectedMetric = 0
    
    let metrics = ["Weight", "Calories", "Macros"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Metric", selection: $selectedMetric) {
                    ForEach(metrics.indices, id: \.self) { index in
                        Text(metrics[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding(16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        switch selectedMetric {
                        case 0:
                            WeightProgressView(user: user, fitnessDataService: fitnessDataService)
                        case 1:
                            CalorieProgressChartView(fitnessDataService: fitnessDataService)
                        case 2:
                            MacroProgressView(fitnessDataService: fitnessDataService)
                        default:
                            Text("Select a metric")
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WeightProgressView: View {
    let user: User?
    @ObservedObject var fitnessDataService: FitnessDataService
    @State private var showAddWeight = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Current Weight
            if let user = user {
                VStack(spacing: 8) {
                    Text("Current Weight")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(String(format: "%.1f", user.weight)) kg")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: { showAddWeight = true }) {
                        Label("Update Weight", systemImage: "plus.circle.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            // Weight History
            VStack(alignment: .leading, spacing: 12) {
                Text("Weight History")
                    .font(.headline)
                    .fontWeight(.bold)
                
                if fitnessDataService.weightEntries.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No weight entries yet")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                } else {
                    VStack(spacing: 8) {
                        ForEach(fitnessDataService.weightEntries) { entry in
                            HStack {
                                Text(formattedDate(entry.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(String(format: "%.1f", entry.weight)) kg")
                                    .fontWeight(.semibold)
                            }
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $showAddWeight) {
            AddWeightView(fitnessDataService: fitnessDataService)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct CalorieProgressChartView: View {
    @ObservedObject var fitnessDataService: FitnessDataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Calorie Intake")
                .font(.headline)
                .fontWeight(.bold)
            
            // Simple chart representation
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Text("Today")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(fitnessDataService.dailyStats?.caloriesConsumed ?? 0)")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue)
                        .frame(height: 30)
                    
                    Spacer()
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            // Macro Breakdown
            VStack(alignment: .leading, spacing: 8) {
                Text("Macro Breakdown")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    MacroBreakdownBar(
                        name: "Protein",
                        value: fitnessDataService.dailyStats?.protein ?? 0,
                        color: .red
                    )
                    MacroBreakdownBar(
                        name: "Carbs",
                        value: fitnessDataService.dailyStats?.carbs ?? 0,
                        color: .blue
                    )
                    MacroBreakdownBar(
                        name: "Fat",
                        value: fitnessDataService.dailyStats?.fat ?? 0,
                        color: .yellow
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct MacroProgressView: View {
    @ObservedObject var fitnessDataService: FitnessDataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Macronutrient Tracking")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                MacroProgressCard(
                    name: "Protein",
                    value: fitnessDataService.dailyStats?.protein ?? 0,
                    goal: 200,
                    unit: "g",
                    color: .red
                )
                MacroProgressCard(
                    name: "Carbohydrates",
                    value: fitnessDataService.dailyStats?.carbs ?? 0,
                    goal: 250,
                    unit: "g",
                    color: .blue
                )
                MacroProgressCard(
                    name: "Fat",
                    value: fitnessDataService.dailyStats?.fat ?? 0,
                    goal: 70,
                    unit: "g",
                    color: .yellow
                )
            }
            
            Spacer()
        }
    }
}

struct MacroBreakdownBar: View {
    let name: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(name)
                .font(.caption2)
                .fontWeight(.bold)
            Text(String(format: "%.0f", value))
                .font(.caption)
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(height: 20)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MacroProgressCard: View {
    let name: String
    let value: Double
    let goal: Double
    let unit: String
    let color: Color
    
    var progress: Double {
        min(value / goal, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(format: "%.1f", value))/\(String(format: "%.0f", goal)) \(unit)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            SwiftUI.ProgressView(value: progress)
                .tint(color)
        }
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct AddWeightView: View {
    @ObservedObject var fitnessDataService: FitnessDataService
    @Environment(\.dismiss) var dismiss
    
    @State private var weight = 70.0
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Weight Entry")) {
                    VStack(alignment: .leading) {
                        Text("Weight: \(String(format: "%.1f", weight)) kg")
                        Slider(value: $weight, in: 30...200, step: 0.1)
                    }
                }
                
                Section {
                    Button(action: {
                        fitnessDataService.addWeightEntry(weight: weight)
                        dismiss()
                    }) {
                        Text("Save Weight")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    ProgressView(user: nil, fitnessDataService: FitnessDataService())
}
