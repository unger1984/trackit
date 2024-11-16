import 'dart:async';

import 'package:trackit/trackit.dart';

/// Main [Trackit] class
/// Singleton, one on all app
/// Use [Trackit.getInstance()] to get instance
class Trackit {
  /// instance of [Trackit] as Singleton
  static Trackit? _instance;

  /// Broadcast Sync Stream Controller for log data
  final _streamController = StreamController<LogData>.broadcast(sync: true);

  /// Map of added observers and it subscription
  final Map<TrackitObserver, StreamSubscription<LogData>> _observers = {};

  Trackit._();

  /// Get instance of [Trackit]
  factory Trackit.getInstance() {
    _instance ??= Trackit._();
    return _instance!;
  }

  static TrackitInstance create(String title) => TrackitInstance.create(title);

  /// Add one log item to stream
  /// [title] - title of the logger instance
  /// [message] - log message
  /// [logLevel] - log level [LogLevel], default [LogLevel.debug]
  /// [exception] - exception
  /// [stackTrace] - stack trace
  void log(
    String title,
    dynamic message, {
    LogLevel logLevel = LogLevel.debug,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _streamController.add(
      LogData.create(
        logLevel,
        title,
        message?.toString() ?? '',
        exception,
        stackTrace,
      ),
    );
  }

  /// Add TrackitObserver to logger and
  /// subscribe it to log data stream
  void add(TrackitObserver observer) {
    _observers[observer] = _streamController.stream
        .listen((LogData logData) => observer.log(logData, null));
  }

  /// Return list of observers by type.
  /// Find [TrackitObserver] by type.
  /// If [isFullChain] is false, then find it only in first chain.
  /// Else, find it in all chains.
  List<T> whereType<T extends TrackitObserver>([bool isFullChain = true]) {
    final result = <T>[];
    for (TrackitObserver observer in _observers.keys) {
      if (observer is T) {
        result.add(observer);
      }
      if (isFullChain) {
        result.addAll(observer.whereType<T>(true));
      }
    }
    return result;
  }

  /// Return first observer by type if exist.
  /// Find [TrackitObserver] by type.
  /// If [isFullChain] is false, then find it only in first chain.
  /// Else, find it in all chains.
  T? firstWhereType<T extends TrackitObserver>([bool isFullChain = true]) {
    final found = whereType<T>();
    if (found.isEmpty) return null;
    return found.first;
  }

  /// Remove [TrackitObserver] by type with it chain.
  /// Only considers the first observers in the chain!
  void remove<T extends TrackitObserver>() {
    final found = firstWhereType<T>(false);
    if (found == null) return;
    _observers[found]?.cancel();
    _observers.remove(found);
  }

  /// Clear all observers chains.
  void clear() {
    for (var item in _observers.values) {
      item.cancel();
    }
    _observers.clear();
  }

  /// Get log data Sync Broadcast Stream
  /// Use this for raw access
  /// !!! Not recommended to use this method !!!
  /// Instead use [add] and [remove]
  Stream<LogData> get stream => _streamController.stream.asBroadcastStream();
}
