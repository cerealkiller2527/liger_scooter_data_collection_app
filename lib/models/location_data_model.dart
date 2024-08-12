class LocationDataModel {
  final double latitude; // Latitude coordinate
  final double longitude; // Longitude coordinate
  final double altitude; // Altitude in meters
  final double accuracy; // Accuracy of the GPS data in meters
  final DateTime timestamp; // Time of the data point

  LocationDataModel({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    required this.timestamp,
  });

  // Converts a LocationDataModel instance into a map for storing in Firestore or local storage
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Creates a LocationDataModel instance from a map (e.g., fetched from Firestore or local storage)
  factory LocationDataModel.fromMap(Map<String, dynamic> map) {
    return LocationDataModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      altitude: map['altitude'],
      accuracy: map['accuracy'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
