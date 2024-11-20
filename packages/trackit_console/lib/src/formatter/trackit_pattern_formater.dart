import 'package:meta/meta.dart';
import 'package:trackit/trackit.dart';

import '../stringify/log_event_string.dart';
import '../stringify/log_event_stringify.dart';
import 'trackit_formatter.dart';

/// Formats log output according to a template.
/// This is a fairly flexible formatter
/// It allows you to flexibly customize the event string by adding or excluding
/// parameters, for each of which you can specify methods for converting
/// to a string
@immutable
class TrackitPatternFormater extends TrackitFormatter<String> {
  final String pattern;
  final LogEventToStringify? _stringify;
  final PostStringify? _post;

  /// Constructor [TrackitPatternFormater]
  ///
  /// [pattern] -  is the pattern to use to format the log output.
  /// It is a string with replaceable patterns. By default it is equels to
  /// ```[{L}] {D} ({T}): {M}\n{E}\n{S}```
  /// Replaceable templates could be:
  ///
  /// |   Pattern    | Description            |
  /// |--------------|------------------------|
  /// | {L}          | LogLevel first         |
  /// | {T}          | Logger instance title  |
  /// | {D}          | Log event time         |
  /// | {M}          | Log event message      |
  /// | {E}          | Log event exception    |
  /// | {S}          | Log event stackTrace   |
  ///
  /// [stringify] -  is a function that converts a log event fields to string.
  /// By default use simple private method _defaultLogEventStringify
  /// To customize the output, use your own implementation of this method.
  ///
  /// [post] -  this function is used for post-processing of the
  /// generated string. Use it if you want, for example, to color the entire
  /// log line or add frames
  ///
  const TrackitPatternFormater({
    this.pattern = '[{L}] {D} ({T}): {M}\n{E}\n{S}',
    LogEventToStringify? stringify,
    PostStringify? post,
  })  : _stringify = stringify,
        _post = post,
        super();

  /// Event to string type converter by default
  LogEventString _defaultLogEventStringify(LogEvent event) {
    return LogEventString(
      level: event.level.name,
      title: event.title,
      time: event.time.toIso8601String(),
      message: event.message?.toString() ?? '',
      exception: event.exception?.toString() ?? '',
      stackTrace: event.stackTrace?.toString() ?? '',
    );
  }

  /// Overriding the formatting method
  @override
  String format(LogEvent event) {
    final eventStrings =
        _stringify?.call(event) ?? _defaultLogEventStringify(event);

    final result = pattern
        .replaceAll(RegExp('{L}'), eventStrings.level)
        .replaceAll(RegExp('{T}'), eventStrings.title)
        .replaceAll(RegExp('{D}'), eventStrings.time)
        .replaceAll(RegExp('{M}'), eventStrings.message)
        .replaceAll(RegExp('{E}'), eventStrings.exception ?? '')
        .replaceAll(RegExp('{S}'), eventStrings.stackTrace ?? '')
        .trim();

    return _post?.call(event, result) ?? result;
  }
}
