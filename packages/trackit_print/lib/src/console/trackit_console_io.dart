import 'package:trackit_print/trackit_print.dart';

/// Print log to console
class TrackitConsole extends TrackitObserver {
  @override
  void log(LogData data, dynamic formatted) {
    (formatted?.toString() ?? data.message?.toString())
        ?.split('\n')
        .forEach(print);
  }
}
