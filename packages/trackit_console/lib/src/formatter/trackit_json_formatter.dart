import 'package:meta/meta.dart';
import 'package:trackit/trackit.dart';

import 'trackit_formatter.dart';

@immutable
final class TrackitJsonFormatter
    extends TrackitFormatter<Map<String, dynamic>> {
  final bool withStackTrace;
  final bool withException;

  const TrackitJsonFormatter({
    this.withException = true,
    this.withStackTrace = true,
  }) : super();

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
