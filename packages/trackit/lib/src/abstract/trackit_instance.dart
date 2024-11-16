import 'package:trackit/trackit.dart';

/// Instance of one Logger
/// Created with Trackit.createLogger(String title)
class TrackitInstance {
  final String _title;

  /// Constructor
  /// [String] title - title of the logger
  const TrackitInstance._(String title) : _title = title;

  factory TrackitInstance.create(String title) => TrackitInstance._(title);

  /// Private method to log data with [Trackit] instance.
  void _log(LogLevel logLevel, dynamic message,
      {Object? exception, StackTrace? stackTrace}) {
    Trackit.getInstance().log(_title, message,
        exception: exception, stackTrace: stackTrace, logLevel: logLevel);
  }

  /// Log a verbose message
  /// [message] - message to log
  /// [exception] - exception to log if exists
  /// [stackTrace] - stack trace to log if exists
  void verbose(dynamic message, {Object? exception, StackTrace? stackTrace}) {
    _log(
      LogLevel.verbose,
      message,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Log a debug message
  /// [message] - message to log
  /// [exception] - exception to log if exists
  /// [stackTrace] - stack trace to log if exists
  void debug(dynamic message, {Object? exception, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, exception: exception, stackTrace: stackTrace);
  }

  /// Log an info message
  /// [message] - message to log
  /// [exception] - exception to log if exists
  /// [stackTrace] - stack trace to log if exists
  void info(dynamic message, {Object? exception, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, exception: exception, stackTrace: stackTrace);
  }

  /// Log a warning message
  /// [message] - message to log
  /// [exception] - exception to log if exists
  /// [stackTrace] - stack trace to log if exists
  void warning(dynamic message, {Object? exception, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message,
        exception: exception, stackTrace: stackTrace);
  }

  /// Log an error message
  /// [message] - message to log
  /// [exception] - exception to log if exists
  /// [stackTrace] - stack trace to log if exists
  void error(dynamic message, {Object? exception, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, exception: exception, stackTrace: stackTrace);
  }

  /// Log a fatal error message
  /// [message] - message to log
  /// [exception] - exception to log if exists
  /// [stackTrace] - stack trace to log if exists
  void fatal(dynamic message, {Object? exception, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, exception: exception, stackTrace: stackTrace);
  }

  /// Get the title of the logger instance
  String get title => _title;
}
