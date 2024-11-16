import 'package:trackit/trackit.dart';
import 'package:trackit_history/src/types.dart';

/// Trackit history observer
class TrackitHistory extends TrackitObserver {
  final int _maxSize;
  final TrackitHistoryList _list = [];

  /// Constructor
  /// [maxSize] - maximum size of the history list, default is 1000
  TrackitHistory({int maxSize = 1000}) : _maxSize = maxSize;

  /// Get the history list
  TrackitHistoryList get list => _list;

  @override
  void log(LogData data, dynamic formatted) {
    _list.add(data);
    if (_list.length > _maxSize) {
      _list.removeAt(0);
    }
  }
}
