import 'package:meta/meta.dart';

import 'console.dart';

/// Class implementing default/fake log output.
@internal
final class ConsoleImpl implements Console {
  const ConsoleImpl();

  /// Default/fake log output implementation
  ///
  /// [message] is the string to output
  ///
  @override
  void log(String message) {
    // ignore: avoid_print
    message.split('\n').forEach(print);
  }
}
