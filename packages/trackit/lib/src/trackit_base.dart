import 'dart:async';

import 'package:meta/meta.dart';

import 'models/log_event.dart';

@immutable
abstract base class TrackitBase extends Stream<LogEvent> {
  bool get hasListener => _controller.hasListener;

  final StreamController<LogEvent> _controller =
      StreamController<LogEvent>.broadcast();

  /// Adds a subscription to [LogEvent] stream.
  ///
  /// On each data event from this stream, the subscriber's [onData] handler
  /// is called. If [onData] is `null`, nothing happens.
  ///
  /// On errors from this stream, the [onError] handler is called with the
  /// error object and possibly a stack trace.
  ///
  /// The [onError] callback must be of type `void Function(Object error)` or
  /// `void Function(Object error, StackTrace)`.
  /// The function type determines whether [onError] is invoked with a stack
  /// trace argument.
  /// The stack trace argument may be [StackTrace.empty] if this stream received
  /// an error without a stack trace.
  ///
  /// Otherwise it is called with just the error object.
  /// If [onError] is omitted, any errors on this stream are considered unhandled,
  /// and will be passed to the current [Zone]'s error handler.
  /// By default unhandled async errors are treated
  /// as if they were uncaught top-level errors.
  ///
  /// If this stream closes and sends a done event, the [onDone] handler is
  /// called. If [onDone] is `null`, nothing happens.
  ///
  /// If [cancelOnError] is `true`, the subscription is automatically canceled
  /// when the first error event is delivered. The default is `false`.
  ///
  /// While a subscription is paused, or when it has been canceled,
  /// the subscription doesn't receive events and none of the
  /// event handler functions are called.
  @override
  StreamSubscription<LogEvent> listen(
    void Function(LogEvent event)? onData, {
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
  void notifyListeners(LogEvent event) {
    if (!hasListener) return;
    _controller.add(event);
  }

  /// Add [LogEvent] to the logger
  void handleEvent(LogEvent event) {
    notifyListeners(event);
  }
}
