import 'package:intl/intl.dart';

class Helpers {
  // Formats a DateTime object into a string with the given format
  static String formatDate(DateTime dateTime, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(dateTime);
  }

  // Converts meters per second to kilometers per hour
  static double convertSpeedToKmh(double speed) {
    return speed * 3.6;
  }

  // Converts kilometers per hour to meters per second
  static double convertKmhToSpeed(double kmh) {
    return kmh / 3.6;
  }

  // Calculates the distance traveled given speed and time (in seconds)
  static double calculateDistance(double speed, int timeInSeconds) {
    return speed * timeInSeconds;
  }

  // Checks if all required permissions are granted
  static bool arePermissionsGranted(Map<String, bool> permissionsStatus) {
    return permissionsStatus.values.every((status) => status);
  }
}
