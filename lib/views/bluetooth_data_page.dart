import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as serial;
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/storage_service.dart'; // Local storage service
import '../services/firebase_service.dart'; // Firebase service
import '../models/session_model.dart'; // Session model
import 'login_page.dart'; // Login page for logout
import 'view_sessions_page.dart'; // Page to view stored sessions
import 'dart:typed_data';

class BluetoothDataPage extends StatefulWidget {
  const BluetoothDataPage({super.key});

  @override
  BluetoothDataPageState createState() => BluetoothDataPageState();
}

class BluetoothDataPageState extends State<BluetoothDataPage> {
  final Logger logger = Logger();
  serial.BluetoothConnection? connection;
  bool isConnecting = false;
  bool isConnected = false;
  String data = "";
  serial.BluetoothDevice? selectedDevice;
  List<serial.BluetoothDevice> devices = [];
  final ScrollController _scrollController = ScrollController();

  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;

  final FirebaseService _firebaseService = FirebaseService(); // Firebase service instance
  final StorageService _storageService = StorageService(); // Storage service instance

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  // Requests necessary permissions for Bluetooth and location
  Future<void> requestPermissions() async {
    logger.i('Requesting permissions');
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse
    ];

    final statuses = await permissions.request();

    if (statuses[Permission.bluetooth]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.locationWhenInUse]!.isGranted) {
      logger.i('All permissions granted');
      scanForDevices();
    } else {
      logger.e('Permissions not granted');
    }
  }

  // Scans for Bluetooth devices and filters for devices with "Liger" in the name
  Future<void> scanForDevices() async {
    try {
      List<serial.BluetoothDevice> pairedDevices = await serial.FlutterBluetoothSerial.instance.getBondedDevices();

      // Filter devices to only include those with "Liger" in the name
      devices = pairedDevices.where((device) => device.name != null && device.name!.contains('Liger')).toList();

      setState(() {
        if (devices.isNotEmpty) {
          selectedDevice = devices[0];
        } else {
          selectedDevice = null;
        }
      });

      logger.i('Paired devices with "Liger" in the name: ${devices.map((d) => d.name).toList()}');
    } catch (e) {
      logger.e('Error during scanning: $e');
    }
  }

  // Connects to the selected Bluetooth device and starts listening for data
  Future<void> connectToDevice() async {
    if (selectedDevice != null) {
      setState(() {
        isConnecting = true;
      });
      try {
        logger.i('Attempting to connect to ${selectedDevice!.name}');
        serial.BluetoothConnection.toAddress(selectedDevice!.address).then((serial.BluetoothConnection connection) {
          logger.i('Connected to ${selectedDevice!.name}');
          this.connection = connection;
          setState(() {
            isConnecting = false;
            isConnected = true;
            startTime = DateTime.now();  // Capture start time
          });

          this.connection?.input?.listen((Uint8List data) {
            setState(() {
              this.data += String.fromCharCodes(data);
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          }).onDone(() async {
            logger.i('Disconnected from ${selectedDevice!.name}');
            setState(() {
              isConnected = false;
              endTime = DateTime.now();  // Capture end time
              duration = endTime!.difference(startTime!);  // Calculate duration
            });

            final sessionData = prepareSessionData();
            await storeSessionData(sessionData);  // Store the session data
          });
        }).catchError((error) {
          logger.e('Failed to connect: $error');
          setState(() {
            isConnecting = false;
            isConnected = false;
          });
        });
      } catch (e) {
        logger.e('Error during connection: $e');
        setState(() {
          isConnecting = false;
          isConnected = false;
        });
      }
    }
  }

  // Disconnects from the Bluetooth device
  void disconnectFromDevice() {
    connection?.finish(); // Close the Bluetooth connection
    setState(() {
      isConnected = false;
      endTime = DateTime.now(); // Capture end time
      duration = endTime!.difference(startTime!); // Calculate duration
    });

    // Store the session data
    final sessionData = prepareSessionData();
    storeSessionData(sessionData);
  }

  // Prepares the session data for storage
  SessionModel prepareSessionData() {
    return SessionModel(
      startTime: startTime!,
      endTime: endTime!,
      duration: duration!.inSeconds,
      deviceName: selectedDevice?.name ?? "Unknown Device",  // Provide a default value if null
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
    connection?.dispose();
    connection = null;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scooter Bluetooth Data'),
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
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;  // Check if mounted before using context
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<serial.BluetoothDevice>(
              value: selectedDevice,
              hint: const Text('Select Liger Device'),
              onChanged: (serial.BluetoothDevice? device) {
                setState(() {
                  selectedDevice = device;
                });
              },
              items: devices.map((serial.BluetoothDevice device) {
                return DropdownMenuItem<serial.BluetoothDevice>(
                  value: device,
                  child: Text(device.name ?? ""),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: isConnecting
                      ? null
                      : isConnected
                          ? null
                          : connectToDevice,
                  child: Text(isConnecting ? 'Connecting...' : 'Connect'),
                ),
                ElevatedButton(
                  onPressed: isConnected ? disconnectFromDevice : null,
                  child: const Text('Disconnect'),
                ),
              ],
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
