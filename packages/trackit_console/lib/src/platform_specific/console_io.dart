import 'dart:io' as io show stdout;

import 'package:meta/meta.dart';

import 'console.dart';

/// Class implementing output of logs to the console via dart:io.
@internal
final class ConsoleImpl implements Console {
  const ConsoleImpl();

  /// IO log output implementation.
  ///
  /// [message] is the string to output
  ///
  @override
  void log(String message) {
    message.split('\n').forEach(
        (str) => io.stdout.hasTerminal ? io.stdout.writeln(str) : print(str));
  }
}
