import 'package:meta/meta.dart';
import 'package:trackit/src/data/data.dart';

import 'instance_interface.dart';
import 'trackit_base.dart';

@immutable
class TrackitInstance implements InstanceInterface {
  final String _title;
  final TrackitBase _base;

  const TrackitInstance(this._title, this._base);

  void _data(LogLevel level, Object? message,
          [Object? error, StackTrace? stackTrace]) =>
      _base.data(
        LogData(
          message: message,
          time: DateTime.now(),
          level: level,
          title: _title,
        ),
      );

  @override
  void log(Object? message) {
    _data(const LogLevel.trace(), message);
  }

  @override
  void debug(Object? message) {
    _data(const LogLevel.debug(), message);
  }

  @override
  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    _data(const LogLevel.error(), message, error, stackTrace);
  }

  @override
  void fatal(Object? message, Object? error, StackTrace? stackTrace) {
    _data(const LogLevel.error(), message, error, stackTrace);
  }

  @override
  void info(Object? message) {
    _data(const LogLevel.info(), message);
  }

  @override
  void warn(Object? message) {
    _data(const LogLevel.warn(), message);
  }
}
