import 'package:meta/meta.dart';

/// Available Log Levels
@immutable
sealed class LogLevel {
  final int level;
  final String name;

  const LogLevel._({
    required this.level,
    required this.name,
  });

  @literal
  const factory LogLevel.trace() = LogLevelTrace;

  @literal
  const factory LogLevel.debug() = LogLevelDebug;

  @literal
  const factory LogLevel.info() = LogLevelInfo;

  @literal
  const factory LogLevel.warn() = LogLevelWarn;

  @literal
  const factory LogLevel.error() = LogLevelError;

  @literal
  const factory LogLevel.fatal() = LogLevelFatal;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LogLevel && level == other.level);

  @override
  int get hashCode => level;
}

final class LogLevelTrace extends LogLevel {
  const LogLevelTrace() : super._(level: 0, name: 'trace');
}

final class LogLevelDebug extends LogLevel {
  const LogLevelDebug() : super._(level: 0, name: 'debug');
}

final class LogLevelInfo extends LogLevel {
  const LogLevelInfo() : super._(level: 0, name: 'info');
}

final class LogLevelWarn extends LogLevel {
  const LogLevelWarn() : super._(level: 0, name: 'warning');
}

final class LogLevelError extends LogLevel {
  const LogLevelError() : super._(level: 0, name: 'error');
}

final class LogLevelFatal extends LogLevel {
  const LogLevelFatal() : super._(level: 0, name: 'fatal');
}
