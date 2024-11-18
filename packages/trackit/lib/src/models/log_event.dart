import 'package:meta/meta.dart';

import 'log_level.dart';

/// This class contains log item data.
@immutable
class LogData implements Comparable<LogData> {
  /// Create [LogData]
  /// [level] - Log Level
  /// [title] - Log instance title
  /// [time] - Log time
  /// [exception] - Exception
  /// [stackTrace] - StackTrace
  /// [message] - Log message
  const LogData({
    required this.level,
    required this.title,
    required this.time,
    this.exception,
    this.stackTrace,
    this.message,
  });

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

  /// Compare [LogData]s by [time]
  @override
  int compareTo(LogData other) => time.compareTo(other.time);
}
