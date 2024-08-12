class EnvironmentalDataModel {
  final double temperature; // Temperature in Celsius
  final int humidity; // Humidity percentage
  final double airQualityIndex; // AQI (Air Quality Index)
  final String weatherCondition; // Description of weather (e.g., Clear, Rainy)
  final DateTime timestamp; // Time of the data point

  EnvironmentalDataModel({
    required this.temperature,
    required this.humidity,
    required this.airQualityIndex,
    required this.weatherCondition,
    required this.timestamp,
  });

  // Converts an EnvironmentalDataModel instance into a map for storing in Firestore or local storage
  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'airQualityIndex': airQualityIndex,
      'weatherCondition': weatherCondition,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Creates an EnvironmentalDataModel instance from a map (e.g., fetched from Firestore or local storage)
  factory EnvironmentalDataModel.fromMap(Map<String, dynamic> map) {
    return EnvironmentalDataModel(
      temperature: map['temperature'],
      humidity: map['humidity'],
      airQualityIndex: map['airQualityIndex'],
      weatherCondition: map['weatherCondition'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
