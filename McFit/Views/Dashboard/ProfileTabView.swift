//
//  ProfileTabView.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI

struct ProfileTabView: View {
    @ObservedObject var authService: AuthenticationService
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = authService.user {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Profile Header
                            VStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)
                                
                                Text(user.displayName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // Personal Information
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Personal Information")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                InfoRow(label: "Age", value: "\(user.age)")
                                InfoRow(label: "Gender", value: user.gender.capitalized)
                                InfoRow(label: "Height", value: "\(String(format: "%.0f", user.height)) cm")
                                InfoRow(label: "Weight", value: "\(String(format: "%.1f", user.weight)) kg")
                                InfoRow(label: "BMI", value: String(format: "%.1f", user.bmi))
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // Fitness Goals
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Fitness Goals")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                InfoRow(label: "Goal", value: user.goal.capitalized)
                                InfoRow(label: "Activity Level", value: user.activityLevel.capitalized)
                                InfoRow(label: "Daily Calorie Goal", value: "\(user.dailyCalorieGoal) kcal")
                                InfoRow(label: "BMR", value: "\(String(format: "%.0f", user.bmr)) kcal")
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // Account Information
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Account")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                InfoRow(label: "Member Since", value: formattedDate(user.createdAt))
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // Sign Out Button
                            Button(action: {
                                authService.logout()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.left.circle.fill")
                                    Text("Sign Out")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Not Logged In")
                            .font(.headline)
                        Text("Please log in to view your profile")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 8)
        .borderBottom()
    }
}

struct BorderBottom: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            Divider()
                .padding(.top, 8)
        }
    }
}

extension View {
    func borderBottom() -> some View {
        self.modifier(BorderBottom())
    }
}

#Preview {
    ProfileTabView(authService: AuthenticationService())
}
