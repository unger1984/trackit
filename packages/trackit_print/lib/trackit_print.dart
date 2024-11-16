/// Part of very simple, lightweight and modular logging system.
/// Trackit is a logger that is expandable with additional modules.
/// This is module for printing and coloring logs to console.
library;

export 'package:trackit/trackit.dart';

export 'src/console/trackit_console_io.dart'
    if (dart.library.html) 'src/console/trackit_console_web.dart';
export 'src/data/trackit_colors.dart';
export 'src/formatter/color_bordered_formatter.dart';
export 'src/formatter/color_formatter.dart';
