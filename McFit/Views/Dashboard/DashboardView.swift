//
//  DashboardView.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var authService: AuthenticationService
    @StateObject private var fitnessDataService: FitnessDataService
    @State private var selectedTab = 0
    
    init(authService: AuthenticationService) {
        self.authService = authService
        let userId = authService.user?.id ?? ""
        _fitnessDataService = StateObject(wrappedValue: FitnessDataService(userId: userId))
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Home Tab
                HomeTabView(
                    user: authService.user,
                    fitnessDataService: fitnessDataService
                )
                .tag(0)
                
                // Food Log Tab
                FoodLogView(fitnessDataService: fitnessDataService)
                    .tag(1)
                
                // Exercise Tab
                ExerciseLogView(fitnessDataService: fitnessDataService)
                    .tag(2)
                
                // Progress Tab
                ProgressView(user: authService.user, fitnessDataService: fitnessDataService)
                    .tag(3)
                
                // Profile Tab
                ProfileTabView(authService: authService)
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Tab Bar
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    TabBarItem(
                        icon: "house.fill",
                        label: "Home",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                    )
                    
                    TabBarItem(
                        icon: "apple.logo",
                        label: "Food",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )
                    
                    TabBarItem(
                        icon: "figure.walk",
                        label: "Exercise",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                    
                    TabBarItem(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Progress",
                        isSelected: selectedTab == 3,
                        action: { selectedTab = 3 }
                    )
                    
                    TabBarItem(
                        icon: "person.fill",
                        label: "Profile",
                        isSelected: selectedTab == 4,
                        action: { selectedTab = 4 }
                    )
                }
                .background(Color(.systemBackground))
                .shadow(radius: 5)
            }
        }
        .onAppear {
            fitnessDataService.setUserId(authService.user?.id ?? "")
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}

#Preview {
    DashboardView(authService: AuthenticationService())
}
