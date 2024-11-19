import 'package:meta/meta.dart';

import '../models/log_event.dart';
import '../models/log_level.dart';
import '../trackit_base.dart';
import 'instance_interface.dart';

@immutable
final class TrackitInstance implements InstanceInterface {
  final String _title;
  final TrackitBase _base;

  const TrackitInstance(this._title, this._base);

  String get title => _title;

  void _handleEvent(LogLevel level, Object? message,
          [Object? error, StackTrace? stackTrace]) =>
      _base.handleEvent(
        LogEvent.create(
          message: message,
          level: level,
          title: _title,
          exception: error,
          stackTrace: stackTrace,
        ),
      );

  @override
  void log(Object? message) {
    _handleEvent(const LogLevel.trace(), message);
  }

  @override
  void debug(Object? message) {
    _handleEvent(const LogLevel.debug(), message);
  }

  @override
  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    _handleEvent(const LogLevel.error(), message, error, stackTrace);
  }

  @override
  void fatal(Object? message, Object? error, StackTrace? stackTrace) {
    _handleEvent(const LogLevel.fatal(), message, error, stackTrace);
  }

  @override
  void info(Object? message) {
    _handleEvent(const LogLevel.info(), message);
  }

  @override
  void warn(Object? message) {
    _handleEvent(const LogLevel.warn(), message);
  }
}
