import 'package:meta/meta.dart';

@immutable
abstract class InstanceInterface {
  void log(Object message);
  void debug(Object? message);
  void info(Object? message);
  void warn(Object? message);
  void error(Object? message, [Object? error, StackTrace? stackTrace]);
  void fatal(Object? message, Object? error, StackTrace? stackTrace);
}
