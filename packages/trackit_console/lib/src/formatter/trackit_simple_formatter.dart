import 'package:meta/meta.dart';
import 'package:trackit/trackit.dart';

import 'trackit_formatter.dart';

@immutable
final class TrackitSimpleFormatter extends TrackitFormatter<String> {
  final bool withStackTrace;
  final bool withException;

  const TrackitSimpleFormatter({
    this.withException = true,
    this.withStackTrace = true,
  }) : super();

  @override
  String format(LogEvent event) {
    final sb = StringBuffer();

    sb.write(
        '[${event.level}] ${event.time.toIso8601String()} {${event.title}} ');

    final messageLines = (event.message?.toString().trim().split('\n') ?? []);
    final exceptionLines =
        withException ? (event.exception?.toString().split('\n') ?? []) : [];
    final stackTraceLines =
        withStackTrace ? (event.exception?.toString().split('\n') ?? []) : [];

    for (var str in messageLines) {
      sb.writeln(str);
    }
    for (var str in exceptionLines) {
      sb.writeln(str);
    }
    for (var str in stackTraceLines) {
      sb.writeln(str);
    }

    return sb.toString().trim();
  }
}
