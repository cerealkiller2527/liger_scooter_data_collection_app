class SessionModel {
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String deviceName;
  final String receivedData;

  SessionModel({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.deviceName,
    required this.receivedData,
  });

  // Converts a SessionModel instance into a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'deviceName': deviceName,
      'receivedData': receivedData,
    };
  }

  // Creates a SessionModel instance from a map (e.g., fetched from Firestore)
  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      duration: map['duration'],
      deviceName: map['deviceName'],
      receivedData: map['receivedData'],
    );
  }
}
