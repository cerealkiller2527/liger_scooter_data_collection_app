import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config/firebase_options.dart'; // Firebase configuration
import 'views/home_page.dart'; // Import HomePage
import 'views/login_page.dart'; // Import LoginPage

void main() async {
  // Ensures that Flutter bindings are initialized before any other initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase with the configuration options from firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Retrieves the currently authenticated user, if any
  User? user = FirebaseAuth.instance.currentUser;

  // Runs the Flutter app, starting with MyApp
  runApp(MyApp(startPage: user == null ? const LoginPage() : const HomePage()));
}

class MyApp extends StatelessWidget {
  final Widget startPage;

  // The constructor accepts a startPage, determining which page to show first
  const MyApp({super.key, required this.startPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liger Scooter Data Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets the primary color theme of the app
      ),
      home: startPage, // Sets the initial page of the app based on the user's authentication status
    );
  }
}
