# 🙏 Devotion

## About The Project

Devotion is a Flutter-based spiritual content platform that combines audio recording, religious content sharing, and book posting capabilities. The app serves as a comprehensive space for users to engage with spiritual content and share their own reflections.

## Built With

* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)
* [Riverpod](https://riverpod.dev/)
* [Dart](https://dart.dev/docs)

## Getting Started

### Prerequisites

* Flutter (Latest Version)
  ```sh
  flutter --version
  ```
* Dart SDK
* Android Studio / VS Code
* Git

### Installation

1. Install Flutter SDK
   ```sh
   # Download Flutter SDK from flutter.dev
   # Add Flutter to your PATH
   # Verify installation
   flutter doctor
   ```

2. Clone the repository
   ```sh
   git clone https://github.com/njogubless/PROJECT-
   ```

3. Navigate to project directory
   ```sh
   cd devotion
   ```

4. Install dependencies
   ```sh
   flutter pub get
   ```

5. Set up Firebase
   ```sh
   # Create Firebase project
   # Download google-services.json
   # Place in android/app/
   # Download GoogleService-Info.plist
   # Place in ios/Runner/
   ```

## Project Structure

```
lib/
├── config/           # App configuration
├── core/            # Core functionality
├── features/        # Feature modules
├── services/        # Services
└── widget/          # Reusable widgets
```

### Key Directories

#### `config/`
- `routes/` - Application routing
- `theme/` - App theming

#### `core/`
- `common/` - Shared components
- `constants/` - App constants
- `error/` - Error handling
- `providers/` - State management
- `util/` - Utilities

#### `features/`
- `admin/` - Admin features
- `articles/` - Article management
- `audio/` - Audio features
- `auth/` - Authentication
- `books/` - Book management
- `Q&A/` - Q&A features

#### `services/`
- `authentication.dart`
- `bookmark_provider.dart`
- `notification_service.dart`
- `search_service.dart`

## Features

### Authentication
- [x] Email/Password Login
- [x] Social Media Login
- [x] User Profile Management

### Audio Platform
- [x] Record Audio
- [x] Playback Controls
- [x] Audio File Management

### Content Management
- [x] Book Posting
- [x] Article Creation
- [x] Q&A Section

### Additional Features
- [x] Content Bookmarking
- [x] Search Functionality
- [x] Push Notifications

## Development Setup

<!-- ### Environment Configuration
Create `.env` file in root: -->

```env
FIREBASE_API_KEY=your_api_key
FIREBASE_APP_ID=your_app_id
```

### Firebase Setup

1. Authentication Setup
   ```sh
   # Enable Auth methods in Firebase Console
   # Configure OAuth providers if needed
   ```

2. Storage Rules
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read: if request.auth != null;
         allow write: if request.auth != null;
       }
     }
   }
   ```

### Required Permissions

#### Android
Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

#### iOS
Add to `Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Need microphone access for audio recording</string>
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  flutter_riverpod: ^2.0.0
  shared_preferences: ^2.0.0
```

## Running the App

```sh
# Debug Mode
flutter run

# Release Mode
flutter run --release
```

## Testing

```sh
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

## Deployment

### Android
```sh
flutter build apk --release
```

### iOS
```sh
flutter build ios --release
```

## Contributing

1. Fork the Project
2. Create Feature Branch (`git checkout -b feature/.....`)
3. Commit Changes (`git commit -m 'Add .....'`)
4. Push to Branch (`git push origin feature/.....`)
5. Open Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Your Name - [@njogubless1](https://x.com/njogubless1) - pnjogubless@gmail.com

Project Link: [https://github.com/njogubless/PROJECT-](https://github.com/njogubless/PROJECT-)

## Acknowledgments

* [Flutter Documentation](https://flutter.dev/docs)
* [Firebase Documentation](https://firebase.google.com/docs)
* [Riverpod Documentation](https://riverpod.dev/docs)