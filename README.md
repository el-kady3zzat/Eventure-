## Overview

Eventure is a Flutter-based mobile application designed to help organizations manage and communicate their events efficiently. It provides real-time updates, notifications, and event details through an interactive and user-friendly interface.

## Features

### User App Features
- **Event Calendar**: Displays upcoming events in a calendar or list view.
- **User Profiles**: Allows users to manage personal data and track saved events.
- **Contact Form**: Enables users to send inquiries directly.
- **Event Details Screen**: Provides complete event information, including time, location, speakers, and fees.
- **Notifications System**: Sends event reminders and updates.
- **Shareable Flyers (Optional)**: Allows users to share event details on social media.

### Admin Dashboard Features
- **Event Management**: Admins can create, edit, and delete events.
- **Analytics & Reports**: Track event participation and engagement.
- **Push Notifications**: Send announcements and updates to users.
- **Role-Based Access**: Restrict permissions based on user roles.

## Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Firestore (Database & Realtime Updates)
- **Authentication**: Firebase Authentication
- **Push Notifications**: Firebase Cloud Messaging (FCM)
- **State Management**: Provider, Riverpod, or Bloc (based on implementation)
- **Version Control**: Git (GitHub)
- **UI/UX**: Material Design, Dark & Light Theme Support
- **Admin Dashboard**: Web-based Flutter app or Firebase Console

## Project Structure

```
Eventure/
├── lib/                 # Flutter application source code
│   ├── main.dart        # Main application entry point
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   ├── widgets/         # Reusable UI components
│   ├── services/        # Business logic and API interactions
│   ├── providers/       # State management
│   ├── admin/           # Admin dashboard components
├── assets/              # Images, icons, and other resources
├── android/             # Android-specific files
├── ios/                 # iOS-specific files
├── test/                # Unit and widget tests
├── pubspec.yaml         # Project dependencies and configurations
├── README.md            # Project documentation
├── firebase.json        # Firebase configuration file
├── .env                 # Environment variables (do not share!)
```

## Installation Guide

1. **Clone the Repository**:

   ```sh
   git clone <repository_url>
   cd Eventure
   ```

2. **Install Dependencies**

   ```sh
   flutter pub get
   ```

3. **Set Up Firebase**

   - Add your Google services JSON files (for Android & iOS) to the project.
   - Ensure `firebase.json` is correctly configured.

4. **Run the App**

   ```sh
   flutter run
   ```

## Firebase Configuration

The app uses Firebase services for authentication, database, and notifications. Ensure the following:

- Firebase is set up with correct API keys in `firebase.json`.
- The `.env` file (excluded here for security) must be configured properly.

## State Management

Eventure utilizes [Provider/Riverpod/Bloc] for managing application state efficiently, ensuring a responsive user experience.

## Packages Used

- **Firebase Core**: [firebase_core](https://pub.dev/packages/firebase_core)
- **Firestore Database**: [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- **Authentication**: [firebase_auth](https://pub.dev/packages/firebase_auth)
- **Push Notifications**: [firebase_messaging](https://pub.dev/packages/firebase_messaging)
- **State Management**: Provider/Riverpod/Bloc
- **UI Components**: [flutter_bloc](https://pub.dev/packages/flutter_bloc), [provider](https://pub.dev/packages/provider)
- **Network Requests**: [http](https://pub.dev/packages/http)
- **Admin Dashboard UI**: Flutter Web, Firebase Console

## Testing

- **Unit Testing**: Located in `test/`
- **Integration Testing**: Using Firebase Test Lab and physical devices

## Deployment

1. **Android**:

   - Build APK: `flutter build apk`
   - Release APK: `flutter build appbundle`

2. **iOS**:

   - Open in Xcode and configure signing.
   - Build: `flutter build ios`
   - Upload to App Store Connect

## Conclusion

Eventure provides a seamless platform for organizations to engage with their audience through event updates, notifications, and interactive features. By leveraging Flutter and Firebase, it ensures a smooth cross-platform experience. Future enhancements could include features like shareable event flyers, gamification elements, and an advanced admin dashboard for better event management.

## Demo

https://drive.google.com/file/d/1UF57A-aCETqaqNZ2psUJmYbpV9GDuo2i/view

