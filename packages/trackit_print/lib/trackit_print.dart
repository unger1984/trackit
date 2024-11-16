/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'package:trackit/trackit.dart';

export 'src/console/trackit_console_io.dart'
    if (dart.library.html) 'src/console/trackit_console_web.dart';
export 'src/data/trackit_colors.dart';
export 'src/formatter/color_bordered_formatter.dart';
export 'src/formatter/color_formatter.dart';
