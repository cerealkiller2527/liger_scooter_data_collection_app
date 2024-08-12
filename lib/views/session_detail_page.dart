import 'package:flutter/material.dart';
import '../models/session_model.dart'; // Import the SessionModel

// Displays the detailed information of a single session
class SessionDetailPage extends StatelessWidget {
  final SessionModel session;

  // Constructor requiring a SessionModel to display its details
  const SessionDetailPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'), // Title of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying session details like device name, start time, end time, and duration
            Text('Device Name: ${session.deviceName ?? 'Unknown'}'),
            Text('Start Time: ${session.startTime}'),
            Text('End Time: ${session.endTime}'),
            Text('Duration: ${session.duration} seconds'),
            const SizedBox(height: 20),
            const Text(
              'Received Data:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Display the data received during the session in a scrollable view
            Expanded(
              child: SingleChildScrollView(
                child: Text(session.receivedData.isNotEmpty ? session.receivedData : 'No data received'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
