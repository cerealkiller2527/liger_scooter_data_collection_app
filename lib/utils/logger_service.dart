import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: Constants.logMethodCount, // Number of method calls to include in log
      errorMethodCount: Constants.logErrorMethodCount, // Number of method calls to include in error logs
      lineLength: Constants.logLineLength, // Maximum length of each log line
      colors: true, // Enable colorful logs
      printEmojis: true, // Include emojis in logs
      dateTimeFormat: DateTimeFormat.onlyTime, // Format for displaying time in logs
    ),
  );

  // Log an informational message
  static void info(String message) {
    _logger.i(message);
  }

  // Log a warning message
  static void warning(String message) {
    _logger.w(message);
  }

  // Log an error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Log a debug message
  static void debug(String message) {
    _logger.d(message);
  }
}
