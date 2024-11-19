import 'package:meta/meta.dart';

/// An object for storing stringified fields [LogEvent].
@immutable
final class LogEventString {
  final String level;
  final String title;
  final String time;
  final String message;
  final String? exception;
  final String? stackTrace;

  LogEventString({
    required this.level,
    required this.title,
    required this.time,
    required this.message,
    this.exception,
    this.stackTrace,
  });
}
