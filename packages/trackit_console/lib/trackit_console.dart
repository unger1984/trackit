/// Part of very simple, lightweight and modular logging system.
/// Trackit is a logger that is expandable with additional modules.
/// This is module for printing logs to console in Dart application.
library;

export 'package:trackit/trackit.dart';

export 'src/trackit_console.dart';
export 'src/trackit_console_io.dart'
    if (dart.library.html) 'src/console/trackit_console_web.dart';
