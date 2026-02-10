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

### Installation from a release on Android

Download the latest version from the [releases page](https://github.com/CapgePau-Uppa/DinoPet-Walker/releases):

1. Download the `.apk` file (Android)
2. Install on your device
3. Authorize sensor access permissions

### Installation from a release on iOS

#### I. Activate developer mode on an iPhone

1. Plug your iPhone into your Mac with the USB cable. 
2. Unlock your iPhone screen. If prompted with "Trust This Computer?", tap Trust and enter your passcode. 
3. On your Mac, open Xcode (just keep it open in the background). 
4. Now, on your iPhone, go to Settings. 
5. Scroll down and tap on Privacy & Security. 
6. Scroll all the way down to the "Security" section, and tap on Developer Mode. (It should now be visible!)
7. Toggle the switch to turn it on. 
8. The iPhone will ask you to restart. Accept. 
9. After restarting, unlock your iPhone. An alert will appear on the screen: tap Turn On and enter your usual passcode.

#### II. Install Dependencies (Brew)

1. On your Mac, open the Terminal app
2. Install Brew by copying and pasting this line:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Once Homebrew is installed, it will enable us to install Flutter on the Mac with this command :
```
brew install flutter
```

#### III. Configure the Project in Xcode

1. In Finder, go to your project's ios folder. 
2. Double-click on the white file named Runner.xcworkspace. (Warning: Never open the blue Runner.xcodeproj file). 
3. In the left sidebar of Xcode, click on the blue Runner folder at the very top. 
4. In the center of the screen, click on the Signing & Capabilities tab. 
5. Look at the Team row:
   - Click on Add an Account... 
   - Log in with your Apple ID (iCloud email and password). 
   - Close the small window once logged in. 
   - Back on the Team row, now select "Your Name (Personal Team)". 
6. Look at the Bundle Identifier row just below:
   - Replace the default text with something unique.
   Example: change com.example.dinopet to com.your_firstname.dinopet.

#### IV. Launch the Installation on the iPhone

Copy / Paste this command in your terminal :
```
flutter run --release
```
This command will install the application on your iPhone

#### V. Final Security Step (On the iPhone)

1. On the iPhone, go to Settings. 
2. Go to General > VPN & Device Management (near the bottom). 
3. Under the "Developer App" section, tap on your email address. 
4. Tap the blue text "Trust [Your Email]" and confirm.

Important Note on the 7-Day Limit: Because you are using a free Apple Developer account, the application certificate is only valid for 7 days. After this period, the app will no longer open. To continue using it, simply plug your iPhone back into your Mac, open your Terminal, and repeat Step IV (flutter run --release) to refresh the certificate.

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
