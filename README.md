# DinoPet-Walker
TER project topic for the year 2026


## Project Explanation

**DinoPet Walker**

**DinoPet Walker** is a fun mobile step-tracking application that transforms your daily physical activity into an interactive experience with a virtual dinosaur pet. The more you walk, the more your dino grows and evolves!

## Features

### Activity Tracking
- Real-time step count retrieval via pedometer
- Daily progress visualization via a three-zone gauge
- Weekly/monthly history and statistics

### Virtual Companion DinoPet
- Personalized choice of your dinosaur at startup
- Evolutionary dinosaur: Your dino grows with your efforts
- Evolution system: Your DinoPet grows with your performance
- Playful progression: 4 growth stages based on your goals

### Statistics & Analysis
- Overview of your performance
- Calculated averages (day, week, month)
- Progress tracking with positive/negative trends
- Clear visualization of your evolution

### Interactive Map (MAP)
- GPS visualization of your movements
- Social aspect: Discover other nearby DinoPet users

### Security
- Secure authentication to protect your data
- Personalized profile with configurable goals
- Password reset

## Installation

### Prerequisites
- **Flutter SDK**: ≥ 3.0.0
- **Dart SDK**: ≥ 3.0.0
- **Android Studio / Xcode** 
- **Phone : Android 8+ / iPhone iOS 13+**
- **Accounts** : Google (Firebase)
- **Permissions** : Movement, GPS
### Installation Steps

#### 1. Clone the repository
```bash
git clone https://github.com/CapgePau-Uppa/DinoPet-Walker.git
cd DinoPet-Walker
```

#### 2. Install dependencies
```bash
flutter pub get
```

#### 3. Check configuration
```bash
flutter doctor
```

#### 4. Launch the application
```bash
flutter run
```

### Installation from a release

Download the latest version from the [releases page](https://github.com/CapgePau-Uppa/DinoPet-Walker/releases):

1. Download the `.apk` file (Android)
2. Install on your device
3. Authorize sensor access permissions

## Architecture

### Project Structure
```
lib/
├── core/              # Global configuration
├── models/            # Data classes
├── services/          # Communication with Firebase (AuthService, FirestoreService)
├── providers/         # State management
├── screens/           # Main screens
│   ├── auth/
│   ├── home/
│   ├── stats/
│   └── map/
├── widgets/           # Reusable components
└── utils/             # Helper functions
```

### Technologies Used