import 'package:meta/meta.dart';

/// Interface for creating output handlers
@immutable
abstract interface class Console {
  const Console();

  /// Override this method to implement your own way of outputting the
  /// generated string to the console or other output device.
  ///
  /// [message] is the string to output
  ///
  @mustBeOverridden
  void log(String message);
}
