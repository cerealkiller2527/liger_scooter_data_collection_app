# Liger Scooter Data Collection App

## Project Overview

The **Liger Scooter Data Collection App** is a mobile application built using Flutter. This app connects to a scooter via Bluetooth to collect and store various data, including connection duration and real-time data received from the scooter. The data is stored both locally on the user's device and in Firebase Firestore for cloud storage.

## Features

- **User Authentication**: Users can register and log in using email and password authentication via Firebase Authentication.
- **Bluetooth Connectivity**: The app connects to a scooter via Bluetooth, specifically filtering for devices named "Liger".
- **Data Collection**: Real-time data is collected from the scooter during the connection, including the time the connection started, ended, and the duration of the session.
- **Data Storage**: The collected data is stored both locally on the device and in Firebase Firestore under the authenticated user's account.
- **View Sessions**: Users can view their past sessions, including the device name, start time, end time, duration, and the data received during the session.

## Project Structure

```plaintext
lib/
│
├── main.dart                        # Entry point of the application
├── models/
│   └── session_model.dart           # Data model representing a session
│
├── services/
│   ├── firebase_service.dart        # Service for interacting with Firebase Authentication and Firestore
│   ├── storage_service.dart         # Service for storing and retrieving sessions locally
│
├── utils/
│   └── logger_service.dart          # Utility service for logging
│
├── views/
│   ├── bluetooth_data_page.dart     # UI for the main Bluetooth data collection page
│   ├── login_page.dart              # UI for the login and registration page
│   ├── session_detail_page.dart     # UI for viewing the details of a single session
│   ├── view_sessions_page.dart      # UI for viewing all past sessions
└── widgets/
    └── custom_widgets.dart          # Custom reusable widgets (if any)
```

## Prerequisites

- **Flutter SDK**: Ensure you have Flutter installed on your machine. You can download it from [Flutter's official website](https://flutter.dev/).
- **Firebase Account**: You need a Firebase project set up to use Firebase Authentication and Firestore.

## Getting Started

### 1. Clone the Repository

Clone this repository to your local machine using:

```bash
git clone https://github.com/yourusername/liger_scooter_data_collection_app.git
```

### 2. Set Up Firebase

1. **Create a Firebase Project**: Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. **Add an Android/iOS App**: Follow the Firebase documentation to add your Android or iOS app to the Firebase project.
3. **Download `google-services.json` (Android)** or **`GoogleService-Info.plist` (iOS)** and place it in the appropriate directory in your Flutter project (`android/app/` for Android and `ios/Runner/` for iOS).
4. **Enable Authentication**: In the Firebase Console, enable Email/Password authentication.
5. **Set Up Firestore**: Create a Firestore database in your Firebase project.

### 3. Install Dependencies

Navigate to the project directory and run the following command to install all necessary dependencies:

```bash
flutter pub get
```

### 4. Running the App

Run the app on an emulator or physical device using:

```bash
flutter run
```

### 5. Permissions

The app requires the following permissions:
- **Bluetooth**
- **Location (for Bluetooth scanning)**
Ensure you grant these permissions when prompted.

## Usage

1. **Register/Login**: Users can create an account or log in using their email and password.
2. **Connect to Scooter**: On the main screen, select a device named "Liger" from the dropdown and click "Connect".
3. **Collect Data**: Once connected, the app will start collecting data from the scooter.
4. **View Sessions**: You can view past sessions by clicking on the history icon in the app bar.

## Contributing

If you would like to contribute to this project, please fork the repository and submit a pull request. Contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, feel free to contact [your email/contact information].

---

Thank you for using the Liger Scooter Data Collection App!