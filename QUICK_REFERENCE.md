# McFit - Quick Reference Guide

## App Structure Overview

### Views Architecture
```
McFitApp (Entry Point)
├── LoginView (If not authenticated)
├── SignupView (Account creation)
└── DashboardView (Main app with tabs)
    ├── HomeTabView (Dashboard/Summary)
    ├── FoodLogView (Food tracking)
    ├── ExerciseLogView (Workout logging)
    ├── ProgressView (Analytics)
    └── ProfileTabView (User info)
```

### Services
- **AuthenticationService**: Manages user authentication with Firebase
- **FitnessDataService**: Handles all Firestore CRUD operations

### Key Data Models
- **User**: Core user profile with fitness data
- **FoodEntry**: Individual food log entries
- **ExerciseEntry**: Workout log entries
- **WeightEntry**: Weight tracking
- **DailyStats**: Aggregated daily statistics

## Quick Start Checklist

- [ ] Install CocoaPods: `sudo gem install cocoapods`
- [ ] Navigate to project: `cd /Users/ehety/Desktop/McFit`
- [ ] Create Podfile: `pod init`
- [ ] Copy provided Podfile contents
- [ ] Install pods: `pod install`
- [ ] Download GoogleService-Info.plist from Firebase Console
- [ ] Add plist file to Xcode (add to McFit target)
- [ ] Open workspace: `open McFit.xcworkspace`
- [ ] Create Firebase project and enable Auth + Firestore
- [ ] Build and run: Cmd+R

## Common Tasks

### Adding a New Feature
1. Create view in `Views/Dashboard/`
2. Add data model in `Models/User.swift`
3. Add service method in `FitnessDataService`
4. Connect to tab in `DashboardView`

### Modifying User Profile
Edit `User` struct in `Models/User.swift`

### Changing Tab Navigation
Edit `DashboardView.swift` - modify TabView and TabBarItem

### Adding Exercise Types
Update `exercises` array in `AddExerciseView`

### Modifying Calorie Goals
Edit `calculateCalorieGoal()` and `calculateBMR()` in `AuthenticationService`

## Firebase Integration Points

### Authentication
- File: `Services/AuthenticationService.swift`
- Methods: `signup()`, `login()`, `logout()`
- State: `@Published var user`, `@Published var isAuthenticated`

### Data Storage
- File: `Services/FitnessDataService.swift`
- Collections: `users/{userId}/foodEntries`, `exerciseEntries`, `weightEntries`
- Operations: `addFoodEntry()`, `fetchFoodEntriesToday()`, etc.

## UI Components Used

- **TabView**: Main navigation
- **Form**: Data input (signup, add food/exercise)
- **ScrollView**: Scrollable content
- **VStack/HStack**: Layout
- **NavigationStack**: Navigation
- **Slider**: Range input
- **Picker**: Selection
- **ProgressView**: Progress visualization
- **Button**: Actions
- **TextField/SecureField**: Text input
- **Image**: Icons using SF Symbols

## State Management

- **@StateObject**: Long-lived objects (AuthenticationService, FitnessDataService)
- **@ObservedObject**: Observed parameters
- **@State**: Local view state
- **@Environment**: System environment values
- **@Published**: Reactive properties

## Firebase Firestore Structure

```
users/{userId}
├── email: string
├── displayName: string
├── age: number
├── weight: number
├── height: number
├── gender: string
├── goal: string
├── activityLevel: string
├── dailyCalorieGoal: number
└── createdAt: timestamp

users/{userId}/foodEntries/{entryId}
├── foodName: string
├── calories: number
├── protein: number
├── carbs: number
├── fat: number
├── quantity: number
├── unit: string
├── date: timestamp
└── createdAt: timestamp

users/{userId}/exerciseEntries/{entryId}
├── exerciseName: string
├── duration: number
├── caloriesBurned: number
├── intensity: string
├── date: timestamp
└── createdAt: timestamp

users/{userId}/weightEntries/{entryId}
├── weight: number
├── date: timestamp
└── createdAt: timestamp
```

## Debugging Tips

### View Firebase Data
- Use Firebase Console → Firestore to inspect data
- Check "Collection" and "Document" structure

### Check Authentication
- Print `authService.isAuthenticated`
- Check Firebase Console → Authentication

### Monitor Errors
- `print()` statements in services
- Check Xcode console for Firebase logs

### Simulator Issues
- Clear app data: Devices → Manage Devices → App
- Restart simulator if needed
- Check all pods are properly linked

## Color Scheme

- **Primary**: `.blue`
- **Success**: `.green`
- **Warning**: `.orange`
- **Error**: `.red`
- **Background**: `Color(.systemBackground)`
- **Secondary Background**: `Color(.systemGray6)`

## Common Error Solutions

| Error | Solution |
|-------|----------|
| Pod library not found | Run `pod install` and use `.xcworkspace` |
| Firebase not initializing | Check GoogleService-Info.plist is in project |
| Auth failing | Enable Email/Password in Firebase Console |
| Firestore read fails | Check security rules and user authentication |
| Data not saving | Verify Firestore collection names match code |

## Performance Tips

- Use `.onAppear()` to fetch data
- Refresh only when necessary
- Use `.lazy` for large lists (if needed in future)
- Cache user data locally if needed

## Next Development Steps

1. Add more exercises to database
2. Implement food database/API integration
3. Add notifications for reminders
4. Implement data export
5. Add weekly/monthly reports
6. Integrate with HealthKit
7. Add social features
8. Implement image uploads

---

**Version**: 1.0  
**Last Updated**: March 31, 2026
