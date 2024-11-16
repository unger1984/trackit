import 'package:trackit/trackit.dart';

/// Base class for all logger formatters
abstract class TrackitFormatter extends TrackitObserver {
  const TrackitFormatter({super.observers});

  /// Formats a log message
  /// Override this method to format a log message
  dynamic format(LogData data, dynamic formatted);

  @override
  void log(LogData data, dynamic formatted) {
    super.log(data, format(data, formatted));
  }
}
