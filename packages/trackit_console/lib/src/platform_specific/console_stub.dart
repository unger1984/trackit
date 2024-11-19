import 'package:meta/meta.dart';

import 'console.dart';

@internal
final class ConsoleImpl implements Console {
  const ConsoleImpl();

  @override
  void log(String message) {
    // ignore: avoid_print
    print(message);
  }
}
