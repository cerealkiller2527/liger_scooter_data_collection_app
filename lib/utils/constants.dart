// API keys, default values, and string literals
class Constants {
  static const String appName = 'Scooter Data Collection';
  static const String bluetoothDevicePrefix = 'Liger';
  
  // Firebase
  static const String firebaseUsersCollection = 'users';
  static const String firebaseSessionsCollection = 'sessions';
  
  // Default Values
  static const double defaultSpeed = 0.0;
  static const double defaultDistance = 0.0;
  static const double defaultTemperature = 20.0; // Celsius
  static const int defaultHumidity = 50; // Percentage
  static const double defaultAQI = 50.0; // Air Quality Index
  static const String defaultWeatherCondition = 'Clear';
  
  // Date & Time Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  
  // Permissions
  static const List<String> requiredPermissions = [
    'bluetooth',
    'locationWhenInUse'
  ];
  
  // Logging
  static const int logMethodCount = 2;
  static const int logErrorMethodCount = 8;
  static const int logLineLength = 120;
}
