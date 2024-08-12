class ActivityDataModel {
  final double speed; // Speed in m/s
  final double distance; // Distance in meters
  final DateTime timestamp; // Time of the data point

  ActivityDataModel({
    required this.speed,
    required this.distance,
    required this.timestamp,
  });

  // Converts an ActivityDataModel instance into a map for storing in Firestore or local storage
  Map<String, dynamic> toMap() {
    return {
      'speed': speed,
      'distance': distance,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Creates an ActivityDataModel instance from a map (e.g., fetched from Firestore or local storage)
  factory ActivityDataModel.fromMap(Map<String, dynamic> map) {
    return ActivityDataModel(
      speed: map['speed'],
      distance: map['distance'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
