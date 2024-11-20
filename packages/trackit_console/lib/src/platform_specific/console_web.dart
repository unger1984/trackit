import 'dart:html' as html show window;

import 'package:meta/meta.dart';

import 'console.dart';

/// Class implementing output of logs to the console via dart:html.
@internal
final class ConsoleImpl implements Console {
  const ConsoleImpl();

  /// Web log output implementation.
  ///
  /// [message] is the string to output
  ///
  @override
  void log(String message) {
    message.split('\n').forEach(html.window.console.log);
  }
}
