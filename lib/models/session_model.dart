import 'activity_data_model.dart';
import 'environmental_data_model.dart';
import 'location_data_model.dart';

class SessionModel {
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // Duration in seconds
  final String deviceName;
  final List<ActivityDataModel> activityData;
  final List<EnvironmentalDataModel> environmentalData;
  final List<LocationDataModel> locationData;
  final String receivedData; // Data received from the Bluetooth device

  SessionModel({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.deviceName,
    required this.activityData,
    required this.environmentalData,
    required this.locationData,
    required this.receivedData,
  });

  // Converts a SessionModel instance into a map for storing in Firestore or local storage
  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'deviceName': deviceName,
      'activityData': activityData.map((data) => data.toMap()).toList(),
      'environmentalData': environmentalData.map((data) => data.toMap()).toList(),
      'locationData': locationData.map((data) => data.toMap()).toList(),
      'receivedData': receivedData,
    };
  }

  // Creates a SessionModel instance from a map (e.g., fetched from Firestore or local storage)
  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      duration: map['duration'],
      deviceName: map['deviceName'],
      activityData: (map['activityData'] as List)
          .map((data) => ActivityDataModel.fromMap(data))
          .toList(),
      environmentalData: (map['environmentalData'] as List)
          .map((data) => EnvironmentalDataModel.fromMap(data))
          .toList(),
      locationData: (map['locationData'] as List)
          .map((data) => LocationDataModel.fromMap(data))
          .toList(),
      receivedData: map['receivedData'],
    );
  }
}
