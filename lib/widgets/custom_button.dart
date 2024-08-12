import 'package:flutter/material.dart';

// A reusable custom button widget used throughout the app
class CustomButton extends StatelessWidget {
  final String label; // The text label displayed on the button
  final VoidCallback onPressed; // Callback function when the button is pressed
  final bool isLoading; // Indicates if the button should display a loading indicator

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Disable the button if loading
      child: isLoading
          ? const CircularProgressIndicator() // Show a loading spinner if loading
          : Text(label), // Otherwise, show the button label
    );
  }
}
