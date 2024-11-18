import 'package:meta/meta.dart';

import 'log_level.dart';

/// This class contains log item data.
@immutable
class LogEvent implements Comparable<LogEvent> {
  /// Create [LogEvent]
  /// [level] - Log Level
  /// [title] - Log instance title
  /// [time] - Log time
  /// [exception] - Exception
  /// [stackTrace] - StackTrace
  /// [message] - Log message
  const LogEvent({
    required this.level,
    required this.title,
    required this.time,
    this.exception,
    this.stackTrace,
    this.message,
  });

  factory LogEvent.create({
    required LogLevel level,
    required String title,
    Object? exception,
    StackTrace? stackTrace,
    Object? message,
  }) =>
      LogEvent(
        level: level,
        title: title,
        time: DateTime.now(),
        message: message,
        exception: exception,
        stackTrace: stackTrace,
      );

  /// Log Level information
  @nonVirtual
  final LogLevel level;

  /// Log instance title
  @nonVirtual
  final String title;

  /// Log date time
  @nonVirtual
  final DateTime time;

  /// Exception information
  @nonVirtual
  final Object? exception;

  /// Stack trace information
  @nonVirtual
  final StackTrace? stackTrace;

  /// Log message data
  @nonVirtual
  final Object? message;

  /// Compare [LogEvent]s by [time]
  @override
  int compareTo(LogEvent other) => time.compareTo(other.time);
}
