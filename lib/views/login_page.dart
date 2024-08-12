import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import '../widgets/custom_button.dart'; // Import the custom button widget
import '../utils/logger_service.dart'; // Import the logger service

// The login page where users can sign in or register
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  // Handles user login
  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      // Attempt to sign in the user with email and password
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If successful, navigate to the home page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Log and display error message
      setState(() {
        _errorMessage = e.message!;
      });
      LoggerService.error('Login failed: ${e.message}');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Handles user registration
  Future<void> _register() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      // Attempt to create a new user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If successful, navigate to the home page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Log and display error message
      setState(() {
        _errorMessage = e.message!;
      });
      LoggerService.error('Registration failed: ${e.message}');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // Title of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Password input field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, // Hide the password input
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator() // Show loading indicator if loading
            else ...[
              // Login button
              CustomButton(
                label: 'Login',
                onPressed: _login,
              ),
              // Register button
              CustomButton(
                label: 'Register',
                onPressed: _register,
              ),
            ],
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              // Display error message if any
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
