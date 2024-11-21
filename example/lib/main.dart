import 'dart:async';

import 'package:example/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:trackit/trackit.dart';

void main() {
  // create logger instance
  final log = Trackit.create('Main');

  // handle all uncaught exception as fatal
  runZonedGuarded(
    () {
      runApp(const App());
    },
    (exception, stackTrace) {
      log.fatal('Uncaught exception', exception, stackTrace);
    },
  );
}
