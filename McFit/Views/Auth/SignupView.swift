//
//  SignupView.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var authService: AuthenticationService
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var age = 25
    @State private var weight = 70.0
    @State private var height = 170.0
    @State private var selectedGender = "male"
    @State private var selectedGoal = "maintain"
    @State private var selectedActivityLevel = "moderate"
    
    let genders = ["male", "female"]
    let goals = ["lose", "maintain", "gain"]
    let activityLevels = ["sedentary", "light", "moderate", "very", "extreme"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                    TextField("Display Name", text: $displayName)
                }
                
                Section(header: Text("Personal Information")) {
                    TextField("Display Name", text: $displayName)
                    
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender.capitalized).tag(gender)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Age: \(age)")
                        Slider(value: .convert(fromInt: $age), in: 13...100, step: 1)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Weight: \(String(format: "%.1f", weight)) kg")
                        Slider(value: $weight, in: 30...200, step: 0.5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Height: \(String(format: "%.0f", height)) cm")
                        Slider(value: $height, in: 140...230, step: 1)
                    }
                }
                
                Section(header: Text("Fitness Goals")) {
                    Picker("Goal", selection: $selectedGoal) {
                        ForEach(goals, id: \.self) { goal in
                            Text(goal.capitalized).tag(goal)
                        }
                    }
                    
                    Picker("Activity Level", selection: $selectedActivityLevel) {
                        ForEach(activityLevels, id: \.self) { level in
                            Text(level.capitalized).tag(level)
                        }
                    }
                }
                
                // Error Message
                if let error = authService.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // Sign Up Button
                Section {
                    Button(action: {
                        authService.signup(
                            email: email,
                            password: password,
                            displayName: displayName,
                            age: age,
                            weight: weight,
                            height: height,
                            gender: selectedGender,
                            goal: selectedGoal,
                            activityLevel: selectedActivityLevel
                        )
                    }) {
                        if authService.isLoading {
                            SwiftUI.ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                    .disabled(authService.isLoading || email.isEmpty || password.isEmpty || displayName.isEmpty)
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }
}

// Helper to convert between Slider and Int
extension Binding {
    static func convert(fromInt: Binding<Int>) -> Binding<Double> {
        Binding<Double>(
            get: { Double(fromInt.wrappedValue) },
            set: { fromInt.wrappedValue = Int($0) }
        )
    }
}

#Preview {
    SignupView(authService: AuthenticationService())
}
