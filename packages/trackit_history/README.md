<p align="center">
❗️❗️❗️ <b>UNDER CONSTRUCTION</b> ❗️❗️❗️
</p>
<p align="center">
You can use it at your own risk. The project is in developer version 0.x.y
</p>

# Trackit History module

[Trackit](https://github.com/unger1984/trackit) is a lightweight and modular logging system for Dart and Flutter. Trackit has a modular structure, which allows 
to avoid unused functionality.

`trackit_history` module for for [Trackit](https://github.com/unger1984/trackit).
It`s used to store a list of recent logger events. It can be used to display logs on the screen in the application 
and to send log history to the developer.

## How to use

```dart
import 'package:trackit/trackit.dart';
import 'package:trackit_history/trackit_history.dart';

void main() {
  final log = Trackit.create('Main instance');
  Trackit().listen((event) {
    TrackitHistory().add(event);
  });

  log.info('This is info message 1');
  log.info('This is info message 2');
  log.info('This is info message 3');
  log.info('This is info message 4');
  log.info('This is info message 5');
  log.info('This is a last info message');

  /// Wait while Trackit sync
  /// Trackit is an asynchronous stream, so you need to wait for all generated events.
  ///
  /// In the real world, this is not necessary, because when calling a method
  /// that will display or send the log history to the user, there will be
  /// interaction with the application interface (going to the screen, calling
  /// the backend URL, etc.), which takes the time necessary for synchronization.
  /// Of course, if you do not log, for example, "War and Peace")
  Future<void>.delayed(Duration(seconds: 1)).then(
        (_) {
      print('History size: ${TrackitHistory().history.length}');

      /// Show last history
      TrackitHistory().history.map((item) => item.message ?? '').forEach(print);

      /// Change history maxSize
      TrackitHistory().setMaxSize(3);
      print('History size: ${TrackitHistory().history.length}');

      /// Show last history
      TrackitHistory().history.map((item) => item.message ?? '').forEach(print);
    },
  );
}
```

## Documentation

For information on how to use all the features of Trackit, see the full [documentation](https://github.com/unger1984/trackit).
