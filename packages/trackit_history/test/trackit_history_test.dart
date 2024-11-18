import 'dart:async';

import 'package:test/test.dart';
import 'package:trackit/trackit.dart';
import 'package:trackit_history/trackit_history.dart';

void main() {
  group('Test TrackitHistory', () {
    StreamSubscription<LogEvent>? subscription;

    setUp(() {
      subscription?.cancel();
    });

    test('should TrackitHistory work', () async {
      final log = Trackit.create('Test instance');
      subscription = Trackit().listen((event) {
        TrackitHistory().add(event);
      });

      log.info('First message');
      log.info('Second message');

      await Future.delayed(const Duration(seconds: 1));
      final history = TrackitHistory().history;
      expect(history.length, 2);
      expect(history.first.message, 'First message');
      expect(history.last.message, 'Second message');
    });

    test('should TrackitHistory setMaxSize work', () async {
      final log = Trackit.create('Test instance');
      TrackitHistory().setMaxSize(1);
      subscription = Trackit().listen((event) {
        TrackitHistory().add(event);
      });

      log.info('First message');
      log.info('Second message');

      await Future.delayed(const Duration(seconds: 1));
      final history = TrackitHistory().history;
      expect(history.length, 1);
      expect(history.first.message, 'Second message');
    });

    test('should TrackitHistory clear work', () async {
      final log = Trackit.create('Test instance');
      subscription = Trackit().listen((event) {
        TrackitHistory().add(event);
      });

      log.info('First message');
      log.info('Second message');

      await Future.delayed(const Duration(seconds: 1));
      TrackitHistory().clear();
      final history = TrackitHistory().history;
      expect(history.length, 0);
    });
  });
}
