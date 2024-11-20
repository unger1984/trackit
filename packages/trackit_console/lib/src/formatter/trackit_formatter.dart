import 'package:meta/meta.dart';
import 'package:trackit/trackit.dart';

/// Interface for implementing formatters
/// Can be used not only as a conversion of logger events to a string, but
/// also to other types specified in the generic
///
@immutable
abstract class TrackitFormatter<T extends Object?> {
  const TrackitFormatter();

  /// Implement this method to create your own custom formatting of logger events
  ///
  /// [event] The logger event to format
  ///
  T format(LogEvent event);
}
