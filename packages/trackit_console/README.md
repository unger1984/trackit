<p align="center">
❗️❗️❗️ <b>UNDER CONSTRUCTION</b> ❗️❗️❗️
</p>
<p align="center">
You can use it at your own risk. The project is in developer version 0.x.y
</p>

# Trackit Console module

Allows you to output your logs like this 

<img src="https://github.com/unger1984/trackit/raw/main/packages/trackit_console/assets/screen1.png" >

or like this 

<img src="https://github.com/unger1984/trackit/raw/main/packages/trackit_console/assets/screen2.png" >

[Trackit](https://github.com/unger1984/trackit) is a lightweight and modular logging system for Dart and Flutter. Trackit has a modular structure, which allows
to avoid unused functionality.

`trackit_console` module for for [Trackit](https://github.com/unger1984/trackit).
It is used to format and output logger events to the console. Thanks to the formatter system, it allows you to flexibly 
customize the output of events to the console. Using packages like [ansicolor](https://pub.dev/packages/ansicolor), 
you can add colors to your console.

In addition, you can use formatters separately, for example, to format the output before sending it to the log 
collection system or for displaying it in an application.

## How to use

```dart
import 'package:trackit/trackit.dart';
import 'package:trackit_console/trackit_console.dart';

void main() {
  Trackit().listen(TrackitConsole(
    formatter: TrackitPatternFormater(),
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
```

## Formatters

#### TrackitJsonFormatter

Converts a log event to a Map<String,dynamic> that can be sent to a log collection system.

### TrackitSimpleFormatter

Used to minimally convert a logger event into a string like this:

```
[info] 2024-11-19T13:20:52.488727 {MAIN} Log info message
```

It has two configuration parameters:

* bool `withException` - Specifies whether to display error information if it exists (default is `true`)
* bool `withStackTrace` - Specifies whether to display stackTrace information if it exists (default is `true`)

### TrackitPatternFormater

Formats log output according to a template. This is a fairly flexible formatter. It allows you to flexibly customize 
the event string by adding or excluding parameters, for each of which you can specify methods for converting to a string.

The template is specified in the template parameter and is a string with replacers that will be replaced with the 
current values from the logger event. Template replacers can take the following values:

|   Pattern    | Description            |
|--------------|------------------------|
| {L}          | LogLevel first         |
| {T}          | Logger instance title  |
| {D}          | Log event time         |
| {M}          | Log event message      |
| {E}          | Log event exception    |
| {S}          | Log event stackTrace   |

In addition, you can specify how the string values of the logger event fields will be formed. To do this, use the 
`stringify` parameter. Pass it a function that forms a LogEventString object containing the string values of the fields. 
This parameter can be used to add colors to part of the output and to format the output. Here is an example of usage:

```dart
import 'package:trackit/trackit.dart';
import 'package:trackit_console/trackit_console.dart';

LogEventString stringifyEvent(LogEvent event) {
  String color() => switch (event.level) {
    LogLevelTrace() => '37m',
    LogLevelDebug() => '34m',
    LogLevelInfo() => '32m',
    LogLevelWarn() => '33m',
    LogLevelError() => '31m',
    LogLevelFatal() => '31m',
  };
  
  return LogEventString(
    level:
        '\x1B[${color(event)}${event.level.name.toUpperCase().substring(0, 1)}\x1B[0m',
    title: event.title.toUpperCase(),
    time: (event.time.millisecondsSinceEpoch ~/ 1000).toString(),
    message: event.message?.toString() ?? '',
  );
}

void main(){
  Trackit().listen(TrackitConsole(
    formatter: TrackitPatternFormater(
      pattern: '[{L}] <{D}> ({T}): {M}\n{E}\n{S}',
      stringify: stringifyEvent,
    ),
  ).onData);

  final log = Trackit.create('MAIN');
  log.info('Hello world!');
  log.debug('Debug message');

  try {
    throw Exception('Test Fatal exception message');
  } catch (exception, stackTrace) {
    log.fatal('catch fatal exception', exception, stackTrace);
  }
}
```
<img src="https://github.com/unger1984/trackit/raw/main/packages/trackit_console/assets/screen1.png" >

In addition, using the post parameter, you can post-process the generated string. For example, add color or a frame to it. 
Here is an example of use:

```dart
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

void main(){
  Trackit().listen(TrackitConsole(
    formatter: TrackitPatternFormater(
      pattern: '[{L}] <{D}> ({T}): {M}\n{E}\n{S}',
      post: (event, value) => [
        '\x1B[${color(event)}┌──────────────────────────────────────────────────────────────────\x1B[0m',
        ...value.split('\n').map((str) => '\x1B[${color(event)}│ $str\x1B[0m'),
        '\x1B[${color(event)}└──────────────────────────────────────────────────────────────────\x1B[0m',
      ].join('\n'),
    ),
  ).onData);

  final log = Trackit.create('MAIN');
  log.info('Hello world!');
  log.debug('Debug message');

  try {
    throw Exception('Test Fatal exception message');
  } catch (exception, stackTrace) {
    log.fatal('catch fatal exception', exception, stackTrace);
  }
}
```
<img src="https://github.com/unger1984/trackit/raw/main/packages/trackit_console/assets/screen2.png" >

See full [documentation](https://github.com/unger1984/trackit) for details.