import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'bluetooth_data_page.dart';

// The home page of the app, which displays either the Bluetooth data collection page or the login page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if a user is currently logged in
    return FirebaseAuth.instance.currentUser == null
        ? const LoginPage() // If not logged in, show the login page
        : const BluetoothDataPage(); // If logged in, show the Bluetooth data collection page
  }
}
