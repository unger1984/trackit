import 'package:trackit/trackit.dart';

/// Base abstract class for trackit observers
abstract class TrackitObserver {
  final List<TrackitObserver> _observers;

  /// Constructor for [TrackitObserver]
  /// [observers] - is a list of children observers,
  /// allow to create chains of observers
  const TrackitObserver({List<TrackitObserver>? observers})
      : _observers = observers ?? const [];

  /// Override this method to add handler of [LogData]
  /// [data] - [LogData] log item
  /// [formatted] - formatted to output
  void log(LogData data, dynamic formatted) {
    /// Resend data to observers chain
    for (TrackitObserver observer in _observers) {
      observer.log(data, formatted);
    }
  }

  /// Return list of observers by type.
  /// Find [TrackitObserver] by type.
  /// If [isFullChain] is false, then find it only in first chain.
  /// Else, find it in all chains.
  List<T> whereType<T extends TrackitObserver>([bool isFullChain = true]) {
    final result = <T>[];
    for (TrackitObserver observer in _observers) {
      if (observer is T) {
        result.add(observer);
      }
      result.addAll(observer.whereType<T>());
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

  /// Getter for observer list
  List<TrackitObserver> get observers => List.unmodifiable(_observers);
}
