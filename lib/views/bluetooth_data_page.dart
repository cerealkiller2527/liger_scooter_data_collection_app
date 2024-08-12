import 'package:flutter/material.dart';
import 'dart:async'; // Import for using Timer
import 'dart:math'; // Import for using Random
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import '../models/session_model.dart';
import '../services/storage_service.dart'; // Local storage service
import '../services/firebase_service.dart'; // Firebase service
import 'login_page.dart'; // Login page for logout
import 'view_sessions_page.dart'; // Page to view stored sessions

class BluetoothDataPage extends StatefulWidget {
  const BluetoothDataPage({super.key});

  @override
  BluetoothDataPageState createState() => BluetoothDataPageState();
}

class BluetoothDataPageState extends State<BluetoothDataPage> {
  bool isConnecting = false;
  bool isConnected = false;
  String data = "";
  final ScrollController _scrollController = ScrollController();

  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;

  final FirebaseService _firebaseService = FirebaseService(); // Firebase service instance
  final StorageService _storageService = StorageService(); // Storage service instance
  Timer? _timer; // Timer to simulate data reception

  @override
  void initState() {
    super.initState();
  }

  // Simulates connecting to a Bluetooth device
  Future<void> connectToDevice() async {
    setState(() {
      isConnecting = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulate connection delay

    setState(() {
      isConnecting = false;
      isConnected = true;
      startTime = DateTime.now();  // Capture start time
    });

    // Start generating dummy IMU data
    startGeneratingDummyData();
  }

  // Starts a timer to generate dummy IMU data every second
  void startGeneratingDummyData() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        // Generate dummy IMU data
        final imuData = generateDummyIMUData();
        data += '$imuData\n'; // Use string interpolation
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  // Generates dummy IMU data
  String generateDummyIMUData() {
    final random = Random();
    final accelX = (random.nextDouble() * 2 - 1).toStringAsFixed(2);
    final accelY = (random.nextDouble() * 2 - 1).toStringAsFixed(2);
    final accelZ = (random.nextDouble() * 2 - 1).toStringAsFixed(2);
    final gyroX = (random.nextDouble() * 500 - 250).toStringAsFixed(2);
    final gyroY = (random.nextDouble() * 500 - 250).toStringAsFixed(2);
    final gyroZ = (random.nextDouble() * 500 - 250).toStringAsFixed(2);

    return 'Accel: ($accelX, $accelY, $accelZ), Gyro: ($gyroX, $gyroY, $gyroZ)';
  }

  // Prepares the session data for storage
  SessionModel prepareSessionData() {
    return SessionModel(
      startTime: startTime!,
      endTime: endTime!,
      duration: duration!.inSeconds,
      deviceName: "Dummy Liger Device",
      receivedData: data,
    );
  }

  // Stores the session data both in Firestore and locally
  Future<void> storeSessionData(SessionModel sessionData) async {
    await Future.wait([
      _firebaseService.saveSession(sessionData),
      _storageService.saveSessionLocally(sessionData),
    ]);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scooter Bluetooth Data (Simulated)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewSessionsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              if (mounted) {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: isConnecting ? null : connectToDevice,
              child: Text(isConnecting ? 'Connecting...' : 'Connect'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Data from Scooter:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(data),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
