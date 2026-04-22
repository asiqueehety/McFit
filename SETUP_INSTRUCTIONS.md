# McFit - Fitness App Setup Guide

## Project Overview

McFit is a comprehensive fitness tracking application built with SwiftUI and powered by Firebase. It's designed as a MyFitnessPal clone with features for tracking food intake, exercise, weight, and overall fitness progress.

## Prerequisites

- Xcode 14.0 or later
- Swift 5.7 or later
- iOS 14.0 or later
- An active Firebase project

## Installation Steps

### 1. Firebase Setup

#### Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a new project"
3. Enter "McFit" as the project name
4. Follow the setup wizard and create the project

#### Register iOS App
1. In the Firebase Console, click "iOS" or "Add app"
2. Enter the Bundle ID: `com.mcfit.app` (or your unique identifier)
3. Download the `GoogleService-Info.plist` file
4. In Xcode, right-click on the project and select "Add Files to McFit"
5. Select the `GoogleService-Info.plist` file
6. Ensure it's added to the "McFit" target

### 2. Add Firebase Dependencies via CocoaPods

#### Install CocoaPods (if not already installed)
```bash
sudo gem install cocoapods
```

#### Create Podfile
Navigate to your project directory and run:
```bash
cd /Users/ehety/Desktop/McFit
pod init
```

#### Edit Podfile
Replace the contents of the Podfile with:
```ruby
platform :ios, '14.0'

target 'McFit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Firebase pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'

end

target 'McFitTests' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase/Core'

end

target 'McFitUITests' do

end
```

#### Install Pods
```bash
pod install
```

### 3. Close Current Xcode Project and Open Xcworkspace

After CocoaPods installation, you MUST close the `.xcodeproj` file and open the `.xcworkspace` file instead:

```bash
cd /Users/ehety/Desktop/McFit
open McFit.xcworkspace
```

### 4. Configure Firebase in Xcode

1. Open the Xcode workspace
2. Select the "McFit" project in the Project Navigator
3. Select the "McFit" target
4. Go to Build Settings
5. Search for "Other Swift Flags"
6. Add `-suppress-warnings` if you see any Firebase warnings

### 5. Enable Authentication Methods in Firebase

1. Go to Firebase Console → Your Project
2. Navigate to Authentication → Sign-in method
3. Enable "Email/Password"
4. Enable "Anonymous" (optional, for future features)

### 6. Create Firestore Database

1. Go to Firebase Console → Your Project
2. Click "Cloud Firestore" in the left menu
3. Click "Create database"
4. Choose "Start in production mode"
5. Select a region close to your users
6. Click "Create"

#### Set Firestore Security Rules

Replace the default rules with:
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /foodEntries/{entry} {
        allow read, write: if request.auth.uid == userId;
      }
      
      match /exerciseEntries/{entry} {
        allow read, write: if request.auth.uid == userId;
      }
      
      match /weightEntries/{entry} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

## App Architecture

### Folder Structure

```
McFit/
├── Models/
│   └── User.swift           # Data models for User, FoodEntry, ExerciseEntry, etc.
├── Services/
│   ├── AuthenticationService.swift    # Firebase Auth management
│   └── FitnessDataService.swift       # Firebase Firestore operations
├── Views/
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   └── SignupView.swift
│   └── Dashboard/
│       ├── DashboardView.swift        # Main tab-based navigation
│       ├── HomeTabView.swift          # Home/Dashboard tab
│       ├── FoodLogView.swift          # Food logging
│       ├── ExerciseLogView.swift      # Exercise logging
│       ├── ProgressView.swift         # Progress tracking
│       └── ProfileTabView.swift       # User profile
├── McFitApp.swift                     # App entry point
└── ContentView.swift                  # Placeholder view
```

### Key Features

1. **User Authentication**
   - Sign up with email and password
   - Login functionality
   - Secure logout
   - Automatic session management

2. **User Profile Setup**
   - Age, weight, height tracking
   - Gender and fitness goal selection
   - Activity level configuration
   - Automatic BMR and calorie goal calculation

3. **Food Tracking**
   - Log food items with macronutrients
   - Track calories, protein, carbs, and fat
   - View daily food consumption
   - Real-time calorie counting

4. **Exercise Tracking**
   - Log various exercises
   - Track duration and intensity
   - Monitor calories burned
   - Pre-loaded exercise list

5. **Progress Tracking**
   - Weight tracking over time
   - Daily calorie intake visualization
   - Macronutrient breakdown
   - Progress charts and statistics

6. **Dashboard**
   - Daily calorie summary
   - Net calorie calculation
   - BMI display
   - Macro distribution visualization

## Building and Running the App

1. Open the workspace in Xcode:
   ```bash
   open /Users/ehety/Desktop/McFit/McFit.xcworkspace
   ```

2. Select a simulator or device
3. Press Cmd+R to build and run
4. Create an account or log in to start using the app

## Troubleshooting

### Firebase Not Initializing
- Ensure `GoogleService-Info.plist` is added to the project and the "McFit" target
- Verify the bundle ID matches your Firebase project

### Pods Not Found
- Run `pod update` to update pod dependencies
- Make sure you're opening `.xcworkspace` not `.xcodeproj`

### Firestore Data Not Saving
- Check Firestore security rules
- Verify user is authenticated
- Check console for error messages

### Authentication Issues
- Ensure Email/Password provider is enabled in Firebase Console
- Check that your email format is valid
- Verify the password meets requirements (8+ characters recommended)

## Future Enhancements

- [ ] Social login (Google, Apple)
- [ ] Barcode scanning for food items
- [ ] Exercise videos and form tips
- [ ] Community features and leaderboards
- [ ] Integration with Apple HealthKit
- [ ] Weekly and monthly reports
- [ ] Meal planning
- [ ] Recipe suggestions
- [ ] Water intake tracking
- [ ] Push notifications for meal reminders

## Testing

The app includes UI tests that can be extended. To run tests:
```bash
Cmd+U in Xcode
```

## License

This project is created for educational purposes.

## Support

For issues and questions, refer to:
- [Firebase Documentation](https://firebase.google.com/docs)
- [SwiftUI Documentation](https://developer.apple.com/tutorials/swiftui)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
