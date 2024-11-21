<p align="center">
    <a href="https://github.com/unger1984/trackit">
        <img src="https://raw.githubusercontent.com/unger1984/trackit/refs/heads/main/assets/logo.svg" width="150">
    </a>
</p>

Full [documentation](https://github.com/unger1984/trackit)

# Trackit

[Trackit](https://github.com/unger1984/trackit) is a lightweight and modular logging system for Dart and Flutter.
[Trackit](https://github.com/unger1984/trackit) has a modular structure, which allows to avoid unused functionality.

`trackit` is base logger module for [Trackit](https://github.com/unger1984/trackit).
Used only to create a log stream from logger instances and the ability to attach handlers to subscribers.

## Motivation

The logging system is an auxiliary module. It should not be a combine and be able to do everything. The basic logger 
module should only be able to generate an event and send it further.

To display, process and collect logger events, it is necessary to use separate modules, which are necessary in each specific case.

Each application has its own requirements for log processing. Some output them to the console, some send them to the 
error collection system (Firebase Crashlytics, Sentry, etc), some display them in the interface, and perhaps all at the same time!

## How to use

```dart
import 'package:trackit/trackit.dart';

void main() {
  /// Subscription to logger events
  Trackit().listen((event) {
    /// Logger event processing
    /// In the real world, it is more logical to use formatters
    /// and output implemented in other Trackit modules
    /// or their own implementations
    print(event.message?.toString());
  });

  /// Creating a logger instance
  final log = Trackit.create('MAIN');

  /// Logger event generation
  log.info('Hello World');
}
```

## Documentation

For information on how to use all the features of Trackit, see the full [documentation](https://github.com/unger1984/trackit).
