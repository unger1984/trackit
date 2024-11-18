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
  const factory LogLevel.trace() = _LogLevelTrace;

  @literal
  const factory LogLevel.debug() = _LogLevelDebug;

  @literal
  const factory LogLevel.info() = _LogLevelInfo;

  @literal
  const factory LogLevel.warn() = _LogLevelWarn;

  @literal
  const factory LogLevel.error() = _LogLevelError;

  @literal
  const factory LogLevel.fatal() = _LogLevelFatal;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LogLevel && level == other.level);

  @override
  int get hashCode => level;
}

final class _LogLevelTrace extends LogLevel {
  const _LogLevelTrace() : super._(level: 0, name: 'trace');
}

final class _LogLevelDebug extends LogLevel {
  const _LogLevelDebug() : super._(level: 0, name: 'debug');
}

final class _LogLevelInfo extends LogLevel {
  const _LogLevelInfo() : super._(level: 0, name: 'info');
}

final class _LogLevelWarn extends LogLevel {
  const _LogLevelWarn() : super._(level: 0, name: 'warning');
}

final class _LogLevelError extends LogLevel {
  const _LogLevelError() : super._(level: 0, name: 'error');
}

final class _LogLevelFatal extends LogLevel {
  const _LogLevelFatal() : super._(level: 0, name: 'fatal');
}
