import 'package:trackit/trackit.dart';

/// Base class for [LogData] filters
abstract class TrackitFilter extends TrackitObserver {
  const TrackitFilter({super.observers});

  /// Returns true if data should be logged
  /// Override this method if you want to filter data by white list
  bool allow(LogData data) => true;

  /// Returns true if data should not be logged
  /// Override this method if you want to filter data by black list
  bool deny(LogData data) => false;

  @override
  void log(LogData data, dynamic formatted) {
    if (allow(data) && !deny(data)) {
      super.log(data, formatted);
    }
  }
}
