import 'package:ansicolor/ansicolor.dart';
import 'package:trackit_color/trackit_color.dart';

/// Type of colors used in the trackit_print package.
typedef TrackitColors = Map<LogLevel, AnsiPen?>;

TrackitColors defaultTrackitColors = {
  LogLevel.verbose: null,
  LogLevel.debug: AnsiPen()..blue(),
  LogLevel.info: AnsiPen()..green(),
  LogLevel.warning: AnsiPen()..yellow(),
  LogLevel.error: AnsiPen()..red(),
  LogLevel.fatal: AnsiPen()..red(),
};
