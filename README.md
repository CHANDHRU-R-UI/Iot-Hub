# IoT Mastery - Smart Learning App for IoT

A complete professional Flutter mobile application for learning IoT, featuring a modern, futuristic UI with cyberpunk aesthetics.

## Features Included in Source

- **Splash Screen**: Animated logo and futuristic entry.
- **Authentication**: Pre-configured for Firebase Auth (Login UI ready).
- **Dashboard**: Glassmorphism, neon UI, category grid.
- **AI Chatbot**: UI ready for integration with LLM APIs.
- **Theming**: Deep dark, neon blue, and cyber red cyberpunk theme.

## Step-by-Step Setup Instructions

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Install [Android Studio](https://developer.android.com/studio) and setup Android Toolchain.
3. Install an IDE like VS Code.

### Installation
1. Navigate to the project directory:
   ```bash
   cd c:\Users\chand\OneDrive\Desktop\iot
   ```
2. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new project named "IoT Mastery".
3. Enable Email/Password Authentication in Authentication > Sign-in method.
4. Setup Firestore Database in Test mode.
5. Use FlutterFire CLI to configure Firebase:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
6. Uncomment `await Firebase.initializeApp();` in `lib/main.dart`.

### Building APK
To build a release APK for presentation/MAD laboratory submission:
```bash
flutter build apk --release
```
The APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

---
*Created for Final Year Engineering Project / Mobile Application Development Laboratory.*
