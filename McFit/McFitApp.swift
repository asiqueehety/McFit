//
//  McFitApp.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import SwiftUI
import FirebaseCore

@main
struct McFitApp: App {
    @StateObject var authService = AuthenticationService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                DashboardView(authService: authService)
            } else {
                LoginView(authService: authService)
            }
        }
    }
}
