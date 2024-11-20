import 'package:meta/meta.dart';
import 'package:trackit/trackit.dart';

import 'trackit_formatter.dart';

/// Simple formatter for converting logger events to a string. Used by
/// default in TrackitConsole if no other is specified.
///
/// An example output looks like this:
/// [info] 2024-11-20T10:47:40.299363 {LogInstanceTitle} Log info message
///
@immutable
final class TrackitSimpleFormatter extends TrackitFormatter<String> {
  final bool withStackTrace;
  final bool withException;

  /// Constructor
  ///
  /// [withException] - Should I add exception information, defaults to true
  /// [withStackTrace] - Should I add stack trace information, defaults to true
  ///
  const TrackitSimpleFormatter({
    this.withException = true,
    this.withStackTrace = true,
  }) : super();

  /// Overriding the formatting method
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
