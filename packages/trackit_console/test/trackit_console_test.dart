import 'package:test/test.dart';
import 'package:trackit/trackit.dart';
import 'package:trackit_console/trackit_console.dart';

void main() {
  group('Trackit Console tests', () {
    test('should TrackitSimpleFormatter work', () {
      final formatter = TrackitSimpleFormatter();
      final event = LogEvent.create(
        level: const LogLevel.debug(),
        title: 'Test logger instance',
        message: 'Test log message',
      );
      final message = formatter.format(event);
      expect(
        message,
        '[debug] ${event.time.toIso8601String()} {Test logger instance} Test log message',
      );
    });

    test('should TrackitJsonFormatter work', () {
      final formatter = TrackitJsonFormatter(
        withException: false,
        withStackTrace: false,
      );
      final event = LogEvent.create(
        level: const LogLevel.debug(),
        title: 'Test logger instance',
        message: 'Test log message',
      );
      final message = formatter.format(event);
      expect(
        message,
        {
          "title": "Test logger instance",
          "level": "debug",
          "time": event.time.millisecondsSinceEpoch ~/ 1000,
          "message": 'Test log message',
        },
      );
    });

    test('should TrackitPatternFormater work', () {
      final formatter = TrackitPatternFormater();
      final event = LogEvent.create(
        level: const LogLevel.debug(),
        title: 'Test logger instance',
        message: 'Test log message',
      );
      final message = formatter.format(event);
      expect(
        message,
        '[debug] ${event.time.toIso8601String()} (Test logger instance): Test log message',
      );
    });

    test('should TrackitPatternFormater post work', () {
      final formatter = TrackitPatternFormater(
        post: (event, result) => '| ${result} |',
      );
      final event = LogEvent.create(
        level: const LogLevel.debug(),
        title: 'Test logger instance',
        message: 'Test log message',
      );
      final message = formatter.format(event);
      expect(
        message,
        '| [debug] ${event.time.toIso8601String()} (Test logger instance): Test log message |',
      );
    });

    test('should TrackitPatternFormater stringify work', () {
      final formatter = TrackitPatternFormater(
        stringify: (event) => LogEventString(
          level: event.level.name.toUpperCase().substring(0, 1),
          title: event.title,
          time: (event.time.millisecondsSinceEpoch ~/ 1000).toString(),
          message: event.message?.toString() ?? '',
        ),
      );
      final event = LogEvent.create(
        level: const LogLevel.debug(),
        title: 'Test logger instance',
        message: 'Test log message',
      );
      final message = formatter.format(event);
      expect(
        message,
        '[D] ${(event.time.millisecondsSinceEpoch ~/ 1000)} (Test logger instance): Test log message',
      );
    });
  });
}
