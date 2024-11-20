import 'package:meta/meta.dart';
import 'package:trackit/trackit.dart';

import 'trackit_formatter.dart';

/// Simple formatter for converting logger events to JSON
/// compatible Map<String,Dynamic>
///
@immutable
final class TrackitJsonFormatter
    extends TrackitFormatter<Map<String, dynamic>> {
  /// Add stack trace to the out?
  final bool withStackTrace;

  /// Add exception to the out?
  final bool withException;

  /// Constructor
  ///
  /// [withException] - Should I add exception information, defaults to true
  /// [withStackTrace] - Should I add stack trace information, defaults to true
  ///
  const TrackitJsonFormatter({
    this.withException = true,
    this.withStackTrace = true,
  }) : super();

  /// Overriding the formatting method
  @override
  Map<String, dynamic> format(LogEvent event) {
    return <String, dynamic>{
      'title': event.title,
      'level': event.level.toString(),
      'time': event.time.millisecondsSinceEpoch ~/ 1000,
      'message': event.message.toString(),
      if (withException) 'exception': event.exception?.toString(),
      if (withStackTrace) 'stack_trace': event.stackTrace.toString(),
    };
  }
}
