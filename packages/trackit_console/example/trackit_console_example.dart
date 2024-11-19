import 'package:trackit/trackit.dart';
import 'package:trackit_console/trackit_console.dart';

String color(LogEvent event) => switch (event.level) {
      LogLevelTrace() => '37m',
      LogLevelDebug() => '34m',
      LogLevelInfo() => '32m',
      LogLevelWarn() => '33m',
      LogLevelError() => '31m',
      LogLevelFatal() => '31m',
    };

LogEventString stringifyEvent(LogEvent event) {
  return LogEventString(
    level:
        '\x1B[${color(event)}${event.level.name.toUpperCase().substring(0, 1)}\x1B[0m',
    title: event.title.toUpperCase(),
    time: (event.time.millisecondsSinceEpoch ~/ 1000).toString(),
    message: event.message?.toString() ?? '',
  );
}

void main() {
  Trackit().listen(TrackitConsole(
    formatter: TrackitPatternFormater(
      pattern: '[{L}] <{D}> ({T}): {M}\n{E}\n{S}',
      stringify: stringifyEvent,
      post: (event, value) => [
        '\x1B[${color(event)}┌──────────────────────────────────────────────────────────────────\x1B[0m',
        ...value.split('\n').map((str) => '\x1B[${color(event)}│\x1B[0m $str'),
        '\x1B[${color(event)}└──────────────────────────────────────────────────────────────────\x1B[0m',
      ].join('\n'),
    ),
  ).onData);

  final log = Trackit.create('MAIN');

  log.info('Hello world!');
  log.info('Log info message');
  log.info('Multiline\nlog\nmessage');

  log.debug('Debug message');
  try {
    throw Exception('Test Error exception message');
  } catch (exception, stackTrace) {
    log.error('catch error exception', exception, stackTrace);
  }
  try {
    throw Exception('Test Fatal exception message');
  } catch (exception, stackTrace) {
    log.fatal('catch fatal exception', exception, stackTrace);
  }
}
