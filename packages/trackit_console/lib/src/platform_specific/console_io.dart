import 'dart:io' as io show stdout;

import 'package:meta/meta.dart';

import 'console.dart';

@internal
final class ConsoleImpl implements Console {
  const ConsoleImpl();

  @override
  void log(String message) {
      io.stdout.writeln(message);
  }
}
