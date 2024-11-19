import 'package:meta/meta.dart';
import 'package:trackit/trackit.dart';

@immutable
abstract class TrackitFormatter<T extends Object?> {
  const TrackitFormatter();
  T format(LogEvent event);
}
