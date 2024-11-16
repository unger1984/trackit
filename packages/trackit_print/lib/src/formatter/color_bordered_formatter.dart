import 'package:trackit_print/trackit_print.dart';

class ColorBorderedFormatter extends ColorFormatter {
  final int _borderWidth;
  final bool _withCorners;

  /// Constructor
  /// [colors] - use if your want to override the default colors
  ColorBorderedFormatter({
    super.observers,
    super.colors,
    int borderWidth = 80,
    bool withCorners = true,
  })  : _borderWidth = borderWidth,
        _withCorners = withCorners;

  @override
  dynamic format(LogData data, dynamic formatted) {
    final result = [
      _getTopLine(),
      ...(formatted?.toString() ?? data.message?.toString() ?? '')
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => '│ $line'),
      _getBottomLine(),
    ].join('\n');

    return super.format(data, result);
  }

  /// Method returns a line for the bottom of the message
  String _getBottomLine({String lineSymbol = '─'}) {
    final line = lineSymbol * _borderWidth;
    if (_withCorners) {
      return '└$line';
    }
    return line;
  }

  /// Method returns a line for the top of the message
  String _getTopLine({String lineSymbol = '─'}) {
    final line = lineSymbol * _borderWidth;
    if (_withCorners) {
      return '┌$line';
    }
    return line;
  }
}
