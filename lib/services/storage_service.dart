import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../models/session_model.dart';
import '../utils/logger_service.dart';

class StorageService {
  // Saves a session locally as a JSON file
  Future<void> saveSessionLocally(SessionModel session) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/bluetooth_sessions';
      final directoryExists = await Directory(path).exists();

      // Create the directory if it doesn't exist
      if (!directoryExists) {
        await Directory(path).create(recursive: true);
      }

      final fileName = 'session_${session.startTime.toIso8601String()}.json';
      final file = File('$path/$fileName');

      await file.writeAsString(jsonEncode(session.toMap()));
      LoggerService.info('Session data stored locally at $path/$fileName');
    } catch (e) {
      LoggerService.error('Failed to store session data locally: $e');
    }
  }

  // Fetches all locally stored sessions
  Future<List<SessionModel>> fetchLocalSessions() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/bluetooth_sessions';
      final directoryExists = await Directory(path).exists();
      if (!directoryExists) return [];

      final files = Directory(path).listSync();
      List<SessionModel> sessions = [];

      for (var file in files) {
        if (file is File && file.path.endsWith('.json')) {
          final String content = await file.readAsString();
          final Map<String, dynamic> sessionData = jsonDecode(content);
          sessions.add(SessionModel.fromMap(sessionData));
        }
      }
      return sessions;
    } catch (e) {
      LoggerService.error('Error fetching sessions from local storage: $e');
      return [];
    }
  }
}
