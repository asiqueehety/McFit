//
//  AuthenticationService.swift
//  McFit
//
//  Created by asiqueehety on 21/3/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        setupAuthStateListener()
    }
    
    func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.fetchUserData(uid: user.uid)
            } else {
                self?.user = nil
                self?.isAuthenticated = false
            }
        }
    }
    
    func signup(email: String, password: String, displayName: String, age: Int, weight: Double, height: Double, gender: String, goal: String, activityLevel: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                return
            }
            
            guard let firebaseUser = result?.user else {
                self.errorMessage = "Failed to create user"
                self.isLoading = false
                return
            }
            
            let bmr = self.calculateBMR(weight: weight, height: height, age: age, gender: gender)
            let dailyCalorieGoal = self.calculateCalorieGoal(bmr: bmr, activityLevel: activityLevel, goal: goal)
            
            let newUser = User(
                id: firebaseUser.uid,
                email: email,
                displayName: displayName,
                age: age,
                weight: weight,
                height: height,
                gender: gender,
                goal: goal,
                activityLevel: activityLevel,
                dailyCalorieGoal: dailyCalorieGoal,
                createdAt: Date()
            )
            
            self.saveUserToFirestore(user: newUser)
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                return
            }
            
            self.isLoading = false
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveUserToFirestore(user: User) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(user),
           let json = try? JSONSerialization.jsonObject(with: encodedData) as? [String: Any] {
            db.collection("users").document(user.id).setData(json) { [weak self] error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.user = user
                    self?.isAuthenticated = true
                }
                self?.isLoading = false
            }
        }
    }
    
    private func fetchUserData(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            if let data = snapshot?.data() {
                let decoder = JSONDecoder()
                let jsonData = try? JSONSerialization.data(withJSONObject: data)
                if let jsonData = jsonData,
                   let user = try? decoder.decode(User.self, from: jsonData) {
                    self?.user = user
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    private func calculateBMR(weight: Double, height: Double, age: Int, gender: String) -> Double {
        if gender.lowercased() == "male" {
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
        } else {
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
        }
    }
    
    private func calculateCalorieGoal(bmr: Double, activityLevel: String, goal: String) -> Int {
        var multiplier: Double
        
        switch activityLevel.lowercased() {
        case "sedentary":
            multiplier = 1.2
        case "light":
            multiplier = 1.375
        case "moderate":
            multiplier = 1.55
        case "very":
            multiplier = 1.725
        case "extreme":
            multiplier = 1.9
        default:
            multiplier = 1.55
        }
        
        let tdee = bmr * multiplier
        
        switch goal.lowercased() {
        case "lose":
            return Int(tdee - 500) // 500 cal deficit
        case "gain":
            return Int(tdee + 500) // 500 cal surplus
        case "maintain":
            return Int(tdee)
        default:
            return Int(tdee)
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
