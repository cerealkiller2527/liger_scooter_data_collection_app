import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../models/session_model.dart'; // Import the SessionModel
import '../utils/logger_service.dart'; // Import the LoggerService
import 'session_detail_page.dart'; // Import the SessionDetailPage

class ViewSessionsPage extends StatefulWidget {
  const ViewSessionsPage({super.key});

  @override
  ViewSessionsPageState createState() => ViewSessionsPageState(); // Made the state class public
}

class ViewSessionsPageState extends State<ViewSessionsPage> {
  // Use LoggerService instead of Logger directly
  List<SessionModel> firestoreSessions = []; // List to store sessions fetched from Firestore
  List<SessionModel> localSessions = []; // List to store sessions fetched from local storage

  @override
  void initState() {
    super.initState();
    fetchSessionsFromFirestore();
    fetchSessionsFromLocalStorage();
  }

  // Fetches sessions from Firestore for the current user
  Future<void> fetchSessionsFromFirestore() async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .get();

      setState(() {
        firestoreSessions = snapshot.docs
            .map((doc) => SessionModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      LoggerService.error('Error fetching sessions from Firestore: $e');
    }
  }

  // Fetches sessions from local storage
  Future<void> fetchSessionsFromLocalStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/bluetooth_sessions';
      final directoryExists = await Directory(path).exists();
      if (!directoryExists) return;

      final files = Directory(path).listSync();
      List<SessionModel> sessions = [];

      for (var file in files) {
        if (file is File && file.path.endsWith('.json')) {
          final String content = await file.readAsString();
          final Map<String, dynamic> sessionData = jsonDecode(content);
          sessions.add(SessionModel.fromMap(sessionData));
        }
      }

      setState(() {
        localSessions = sessions;
      });
    } catch (e) {
      LoggerService.error('Error fetching sessions from local storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Sessions'),
      ),
      body: ListView(
        children: [
          // Display sessions fetched from Firestore
          ListTile(
            title: const Text('Sessions from Firestore'),
            subtitle: Text('${firestoreSessions.length} sessions found'),
          ),
          ...firestoreSessions.map((session) {
            return ListTile(
              title: Text(session.deviceName ?? 'Unknown Device'),
              subtitle: Text('Start: ${session.startTime}, Duration: ${session.duration}s'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionDetailPage(session: session), // Navigate to session details page
                  ),
                );
              },
            );
          }),
          const Divider(),
          // Display sessions fetched from local storage
          ListTile(
            title: const Text('Sessions from Local Storage'),
            subtitle: Text('${localSessions.length} sessions found'),
          ),
          ...localSessions.map((session) {
            return ListTile(
              title: Text(session.deviceName ?? 'Unknown Device'),
              subtitle: Text('Start: ${session.startTime}, Duration: ${session.duration}s'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionDetailPage(session: session), // Navigate to session details page
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
