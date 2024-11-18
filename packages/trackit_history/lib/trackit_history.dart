/// Part of very simple, lightweight and modular logging system.
/// Trackit is a logger that is expandable with additional modules.
/// This is module for storing logs in memory.
library;

import 'package:trackit/trackit.dart';

typedef TrackitHistoryList = List<LogEvent>;

/// Trackit history observer
class TrackitHistory {
  int _maxSize = 1000;
  final TrackitHistoryList _history = [];

  factory TrackitHistory() => _internalSingleton;

  TrackitHistory._internal();
  static final TrackitHistory _internalSingleton = TrackitHistory._internal();

  void setMaxSize(int size) {
    _maxSize = size;
    if (_history.length > _maxSize) {
      _history.removeRange(0, _history.length - _maxSize);
    }
  }

  /// Get the unmodifiable history list
  TrackitHistoryList get history => List.unmodifiable(_history);

  /// Clear the history list
  void clear() {
    _history.clear();
  }

  void add(LogEvent event) {
    _history.add(event);
    if (_history.length > _maxSize) {
      _history.removeAt(0);
    }
  }
}
