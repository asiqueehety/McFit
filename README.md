# McFit - Fitness Tracking Application

A comprehensive fitness tracking app built with SwiftUI and Firebase, designed to help users monitor their nutrition, exercise, weight, and overall fitness progress.

## 🎯 Key Features

### 🔐 Authentication
- User registration with personalized fitness profile
- Secure login/logout
- Email-based authentication
- Profile information: age, weight, height, gender, fitness goals, activity level

### 📱 Dashboard
- Real-time calorie tracking
- Daily summary with consumed vs. burned calories
- BMI calculation and display
- Net calorie remaining calculation
- Macro visualization (Protein, Carbs, Fat)

### 🍎 Food Logging
- Easy food entry with nutrition information
- Macro tracking (Protein, Carbs, Fat)
- Calorie calculation based on quantity
- Food history for the day
- Customizable units (g, ml, pieces, etc.)

### 💪 Exercise Logging
- Extensive exercise database with 15+ common exercises
- Duration and intensity tracking
- Calories burned calculation
- Exercise history with details
- Intensity levels: Light, Moderate, Vigorous

### 📊 Progress Tracking
- Weight tracking over time
- Calorie intake visualization
- Macro breakdown charts
- Progress history
- BMI monitoring

### 👤 User Profile
- Display all user information
- Personal stats (BMI, BMR, calorie goals)
- Fitness goal overview
- Activity level display
- Account management

## 🛠️ Technology Stack

- **Language**: Swift 5.7+
- **UI Framework**: SwiftUI
- **Backend**: Firebase (Auth + Firestore)
- **Minimum iOS**: 14.0
- **Architecture**: MVVM with ObservableObject

## 📋 Models

### User
- ID, Email, Display Name
- Personal Info: Age, Weight, Height, Gender
- Fitness Profile: Goal, Activity Level, Daily Calorie Goal
- Computed Properties: BMI, BMR

### FoodEntry
- Food Name, Calories, Macronutrients
- Quantity and Unit
- Date and Timestamp

### ExerciseEntry
- Exercise Name, Duration, Calories Burned
- Intensity Level
- Date and Timestamp

### WeightEntry
- Weight, Date, Timestamp

### DailyStats
- Calorie Summary (Consumed, Burned, Net)
- Macro Totals
- Water Intake

## 🔄 Data Flow

1. **Authentication Service**: Manages Firebase Auth
2. **Fitness Data Service**: CRUD operations on Firestore
3. **Views**: Display data and handle user interaction
4. **Models**: Define data structure

## 🎨 UI/UX

- **Tabbed Navigation**: 5 main sections (Home, Food, Exercise, Progress, Profile)
- **Color Scheme**: Blue-based with accent colors for macros
- **Icons**: SF Symbols throughout
- **Responsive Design**: Adapts to all screen sizes

## 📐 Calorie Calculation

### BMR (Basal Metabolic Rate)
- **Men**: (10 × weight) + (6.25 × height) - (5 × age) + 5
- **Women**: (10 × weight) + (6.25 × height) - (5 × age) - 161

### Daily Calorie Goal
- Based on BMR × Activity Multiplier
- Adjusted for goal (lose: -500, gain: +500, maintain: 0)

## 🔒 Security

- User data is private and only accessible by the authenticated user
- Firestore rules enforce user-level data isolation
- Passwords are hashed and managed by Firebase Auth
- All communications are encrypted

## 📥 Installation & Setup

See [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed setup instructions.

## 🎓 Learning Resources

- [SwiftUI Official Documentation](https://developer.apple.com/tutorials/swiftui)
- [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)

## 🐛 Known Limitations

- No barcode scanning (planned enhancement)
- No offline support (requires internet connection)
- No social features (planned enhancement)
- No HealthKit integration (planned enhancement)

## 🚀 Future Enhancements

- [ ] Barcode scanner for quick food logging
- [ ] Apple HealthKit integration
- [ ] Social sharing and challenges
- [ ] AI-powered meal recommendations
- [ ] Advanced progress analytics
- [ ] Offline mode
- [ ] Watch app companion
- [ ] Dark mode support enhancement

## 👨‍💻 Development

The app is structured to be easily extendable. Each tab view can be enhanced independently:

```
Services → Models → Views → UI Components
```

Feel free to:
- Add new food categories
- Extend exercise database
- Add social features
- Integrate HealthKit
- Add notifications

## 📄 File Structure Quick Reference

```
McFit/
├── Models/User.swift              # All data models
├── Services/
│   ├── AuthenticationService.swift  # Firebase Auth
│   └── FitnessDataService.swift    # Firestore operations
├── Views/
│   ├── Auth/                       # Login & Signup
│   ├── Dashboard/                  # Main app views
│   └── Components/                 # Reusable UI components
└── McFitApp.swift                  # App entry point
```

## 📞 Support

For Firebase setup issues, refer to:
- [Firebase Console](https://console.firebase.google.com)
- Firebase emulator for local testing

---

**Happy Fitness Tracking! 💪**
