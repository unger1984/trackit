import 'dart:html';

import 'package:trackit_console/trackit_console.dart';

/// Print log to console
class TrackitConsole extends TrackitObserver {
  @override
  void log(LogEvent data, dynamic formatted) {
    (formatted?.toString() ?? data.message?.toString())
        ?.split('\n')
        .forEach(window.console.log);
  }
}
