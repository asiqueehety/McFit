//
//  FoodLogView.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI

struct FoodLogView: View {
    @ObservedObject var fitnessDataService: FitnessDataService
    @State private var showAddFood = false
    @State private var selectedFood: FoodEntry?
    
    var groupedFoodEntries: [(String, [FoodEntry])] {
        let grouped = Dictionary(grouping: fitnessDataService.foodEntries) { entry in
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: entry.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if fitnessDataService.foodEntries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No Food Logged Today")
                            .font(.headline)
                        Text("Start by adding your meals")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Daily Total
                            VStack(spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Total Calories")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(fitnessDataService.dailyStats?.caloriesConsumed ?? 0)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Total Protein")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(String(format: "%.1f", fitnessDataService.dailyStats?.protein ?? 0))g")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .padding(16)
                            
                            // Food Entries
                            ForEach(fitnessDataService.foodEntries) { entry in
                                FoodEntryRow(entry: entry)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .navigationTitle("Food Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddFood = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddFood) {
                AddFoodView(fitnessDataService: fitnessDataService)
            }
            .onAppear {
                fitnessDataService.fetchTodayData()
            }
        }
    }
}

struct FoodEntryRow: View {
    let entry: FoodEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.foodName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(entry.quantity, specifier: "%.1f") \(entry.unit)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(entry.totalCalories)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("kcal")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            HStack(spacing: 12) {
                MacroRow(title: "P", value: entry.protein, color: .red)
                MacroRow(title: "C", value: entry.carbs, color: .blue)
                MacroRow(title: "F", value: entry.fat, color: .yellow)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct MacroRow: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(String(format: "%.1f", value))
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .padding(6)
        .background(color.opacity(0.1))
        .cornerRadius(6)
    }
}

struct AddFoodView: View {
    @ObservedObject var fitnessDataService: FitnessDataService
    @Environment(\.dismiss) var dismiss
    
    @State private var foodName = ""
    @State private var calories = 100
    @State private var protein = 10.0
    @State private var carbs = 10.0
    @State private var fat = 5.0
    @State private var quantity = 100.0
    @State private var unit = "g"
    
    let units = ["g", "ml", "piece", "cup", "tbsp", "tsp"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Food Information")) {
                    TextField("Food Name", text: $foodName)
                    
                    VStack(alignment: .leading) {
                        Text("Calories: \(calories)")
                        Slider(value: .convert(fromInt: $calories), in: 0...1000, step: 1)
                    }
                }
                
                Section(header: Text("Macronutrients")) {
                    VStack(alignment: .leading) {
                        Text("Protein: \(String(format: "%.1f", protein))g")
                        Slider(value: $protein, in: 0...100, step: 0.5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Carbs: \(String(format: "%.1f", carbs))g")
                        Slider(value: $carbs, in: 0...100, step: 0.5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Fat: \(String(format: "%.1f", fat))g")
                        Slider(value: $fat, in: 0...100, step: 0.5)
                    }
                }
                
                Section(header: Text("Quantity")) {
                    VStack(alignment: .leading) {
                        Text("Quantity: \(String(format: "%.1f", quantity))")
                        Slider(value: $quantity, in: 0.1...1000, step: 0.1)
                    }
                    
                    Picker("Unit", selection: $unit) {
                        ForEach(units, id: \.self) { u in
                            Text(u).tag(u)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        fitnessDataService.addFoodEntry(
                            foodName: foodName,
                            calories: calories,
                            protein: protein,
                            carbs: carbs,
                            fat: fat,
                            quantity: quantity,
                            unit: unit
                        )
                        dismiss()
                    }) {
                        Text("Add Food")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    .disabled(foodName.isEmpty)
                }
            }
            .navigationTitle("Add Food")
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
    FoodLogView(fitnessDataService: FitnessDataService())
}
