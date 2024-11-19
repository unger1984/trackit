/// Part of very simple, lightweight and modular logging system.
/// Trackit is a logger that is expandable with additional modules.
/// This is module for printing logs to console in Dart application.
library;

import 'package:trackit/trackit.dart';

import 'src/platform_specific/console_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'src/platform_specific/console_web.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'src/platform_specific/console_io.dart';
import 'trackit_console.dart';

export 'src/formatter/trackit_formatter.dart';
export 'src/formatter/trackit_json_formatter.dart';
export 'src/formatter/trackit_pattern_formater.dart';
export 'src/formatter/trackit_simple_formatter.dart';
export 'src/platform_specific/console.dart';
export 'src/stringify/log_event_string.dart';
export 'src/stringify/log_event_stringify.dart';

final class TrackitConsole {
  final Console _console;
  final TrackitFormatter<String> _formatter;

  const TrackitConsole({
    Console? console,
    TrackitFormatter<String>? formatter,
  })  : _console = console ?? const ConsoleImpl(),
        _formatter = formatter ?? const TrackitSimpleFormatter();

  void onData(LogEvent event) {
    _console.log(_formatter.format(event));
  }
}
