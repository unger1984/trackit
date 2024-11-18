import 'package:ansicolor/ansicolor.dart';
import 'package:trackit_color/trackit_color.dart';

class ColorFormatter extends TrackitFormatter {
  final TrackitColors _colors;

  /// Constructor
  /// [colors] - use if your want to override the default colors
  ColorFormatter({super.observers, TrackitColors? colors})
      : _colors = colors ?? defaultTrackitColors {
    ansiColorDisabled = false;
  }

  /// Colorize the given [wrd] if exist given [pen]
  String color(String wrd, [AnsiPen? pen]) {
    return pen?.write(wrd) ?? wrd;
  }

  @override
  dynamic format(LogEvent data, dynamic formatted) {
    return (formatted?.toString() ?? data.message?.toString() ?? '')
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => color(line, _colors[data.level]))
        .join('\n');
  }
}
