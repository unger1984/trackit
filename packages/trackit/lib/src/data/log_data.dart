import 'package:trackit/trackit.dart';

/// This class contains log item data.
class LogData {
  final LogLevel level;
  final String title;
  final DateTime time;
  final Object? exception;
  final StackTrace? stackTrace;
  final dynamic message;

  const LogData._({
    required this.level,
    required this.title,
    required this.time,
    this.exception,
    this.stackTrace,
    this.message,
  });

  factory LogData.create(
    LogLevel level,
    String title, [
    dynamic message,
    Object? exception,
    StackTrace? stackTrace,
  ]) =>
      LogData._(
        time: DateTime.now(),
        level: level,
        title: title,
        message: message,
        exception: exception,
        stackTrace: stackTrace,
      );
}
