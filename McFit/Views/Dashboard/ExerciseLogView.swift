//
//  ExerciseLogView.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI

struct ExerciseLogView: View {
    @ObservedObject var fitnessDataService: FitnessDataService
    @State private var showAddExercise = false

    var body: some View {
        NavigationStack {
            VStack {
                if fitnessDataService.exerciseEntries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No Exercise Logged Today")
                            .font(.headline)
                        Text("Start by adding your workouts")
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
                                        Text("Calories Burned")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(fitnessDataService.dailyStats?.caloriesBurned ?? 0)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Total Duration")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(totalDuration())")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .padding(16)

                            // Exercise Entries
                            ForEach(fitnessDataService.exerciseEntries) { entry in
                                ExerciseEntryRow(entry: entry)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .navigationTitle("Exercise Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddExercise = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddExercise) {
                AddExerciseView(fitnessDataService: fitnessDataService)
            }
            .onAppear {
                fitnessDataService.fetchTodayData()
            }
        }
    }

    private func totalDuration() -> String {
        let total = fitnessDataService.exerciseEntries.reduce(0) { $0 + $1.duration }
        return "\(total) min"
    }
}

struct ExerciseEntryRow: View {
    let entry: ExerciseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.exerciseName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    HStack(spacing: 8) {
                        Label("\(entry.duration) min", systemImage: "timer")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Label(entry.intensity.capitalized, systemImage: "bolt.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(entry.caloriesBurned)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("kcal")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

struct AddExerciseView: View {
    @ObservedObject var fitnessDataService: FitnessDataService
    @Environment(\.dismiss) var dismiss

    @State private var exerciseName = ""
    @State private var duration = 30
    @State private var caloriesBurned = 150
    @State private var selectedIntensity = "moderate"

    let exercises = [
        "Running", "Walking", "Cycling", "Swimming", "Weight Training",
        "Yoga", "Basketball", "Tennis", "Soccer", "Dancing",
        "Elliptical", "Rowing", "Jump Rope", "Hiking", "CrossFit"
    ]
    let intensities = ["light", "moderate", "vigorous"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Exercise Information")) {
                    Picker("Exercise", selection: $exerciseName) {
                        ForEach(exercises, id: \.self) { exercise in
                            Text(exercise).tag(exercise)
                        }
                    }
                    .onAppear {
                        if exerciseName.isEmpty {
                            exerciseName = exercises[0]
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Duration: \(duration) minutes")
                        Slider(value: .convert(fromInt: $duration), in: 1...180, step: 1)
                    }

                    VStack(alignment: .leading) {
                        Text("Calories Burned: \(caloriesBurned)")
                        Slider(value: .convert(fromInt: $caloriesBurned), in: 10...1000, step: 10)
                    }
                }

                Section(header: Text("Intensity")) {
                    Picker("Intensity Level", selection: $selectedIntensity) {
                        ForEach(intensities, id: \.self) { intensity in
                            Text(intensity.capitalized).tag(intensity)
                        }
                    }
                }

                Section {
                    Button("Add Exercise") {
                        fitnessDataService.addExerciseEntry(
                            exerciseName: exerciseName,
                            duration: duration,
                            caloriesBurned: caloriesBurned,
                            intensity: selectedIntensity
                        )
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ExerciseLogView(fitnessDataService: FitnessDataService())
}
