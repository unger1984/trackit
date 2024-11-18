import 'dart:async';

import 'package:meta/meta.dart';

import 'log_data.dart';

@immutable
abstract class LoggerBase extends Stream<LogData> {
  /// Add [LogData] to the logger
  void log(LogData data);

  bool get hasListener => _controller.hasListener;

  final StreamController<LogData> _controller =
      StreamController<LogData>.broadcast();

  @override
  StreamSubscription<LogData> listen(
    void Function(LogData data)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError = false,
  }) =>
      _controller.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError ?? false,
      );

  /// Notify subscribers
  @protected
  @visibleForOverriding
  void notifyListeners(LogData data) {
    if (!hasListener) return;
    _controller.add(data);
  }
}
