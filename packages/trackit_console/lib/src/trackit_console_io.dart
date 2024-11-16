import 'package:trackit_console/trackit_console.dart';

/// Print log to console
class TrackitConsole extends TrackitObserver {
  @override
  void log(LogData data, dynamic formatted) {
    (formatted?.toString() ?? data.message?.toString())
        ?.split('\n')
        .forEach(print);
  }
}
