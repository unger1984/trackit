import 'dart:html' as html show window;

import 'package:meta/meta.dart';

import 'console.dart';

@internal
final class ConsoleImpl implements Console {
  const ConsoleImpl();

  @override
  void log(String message) {
    html.window.console.log(message);
  }
}
