import 'package:test/test.dart';
import 'package:trackit/trackit.dart';

class TestObserver extends TrackitObserver {}

void main() {
  group('Trackit', () {
    tearDown(() {
      Trackit.getInstance().clear();
    });

    test('should log data', () {
      final trackit = Trackit.getInstance();
      expectLater(
        trackit.stream,
        emitsInOrder([
          predicate<LogData>((data) {
            expect(data.message == 'test', true);
            expect(data.level == LogLevel.debug, true);
            expect(data.title == 'test', true);
            return true;
          }),
        ]),
      );
      trackit.log('test', 'test');
    });

    test('should add observer', () {
      final trackit = Trackit.getInstance();
      final observer = TestObserver();
      trackit.add(observer);
      expect(trackit.observers, contains(observer));
    });

    test('should return list of observers by type', () {
      final trackit = Trackit.getInstance();
      final observer1 = TestObserver();
      final observer2 = TestObserver();
      trackit.add(observer1);
      trackit.add(observer2);
      expect(
        trackit.whereType<TestObserver>(),
        containsAll([observer1, observer2]),
      );
    });

    test('should return first observer by type', () {
      final trackit = Trackit.getInstance();
      final observer1 = TestObserver();
      final observer2 = TestObserver();
      trackit.add(observer1);
      trackit.add(observer2);
      expect(trackit.firstWhereType<TestObserver>(), observer1);
    });

    test('should remove observer by type', () {
      final trackit = Trackit.getInstance();
      final observer = TestObserver();
      trackit.add(observer);
      trackit.remove<TrackitObserver>();
      expect(trackit.observers, isEmpty);
    });

    test('should clear all observers', () {
      final trackit = Trackit.getInstance();
      final observer1 = TestObserver();
      final observer2 = TestObserver();
      trackit.add(observer1);
      trackit.add(observer2);
      trackit.clear();
      expect(trackit.observers, isEmpty);
    });
  });

  group('Base logger tests', () {
    test('should create instance with title', () {
      final log = Trackit.create('test');
      expect(log.title == 'test', true);
    });

    test('should log verbose message', () {
      final log = Trackit.create('test1');
      expectLater(
          Trackit.getInstance().stream,
          emitsInOrder([
            predicate<LogData>((msg) {
              expect(msg.message == 'test message', true);
              expect(msg.level == LogLevel.verbose, true);
              expect(msg.title == 'test1', true);
              return true;
            })
          ]));
      log.verbose('test message');
    });

    test('should log debug message', () {
      final log = Trackit.create('test2');
      expectLater(
          Trackit.getInstance().stream,
          emitsInOrder([
            predicate<LogData>((msg) {
              expect(msg.message == 'test message', true);
              expect(msg.level == LogLevel.debug, true);
              expect(msg.title == 'test2', true);
              return true;
            })
          ]));
      log.debug('test message');
    });

    test('should log info message', () {
      final log = Trackit.create('test3');
      expectLater(
          Trackit.getInstance().stream,
          emitsInOrder([
            predicate<LogData>((msg) {
              expect(msg.message == 'test message', true);
              expect(msg.level == LogLevel.info, true);
              expect(msg.title == 'test3', true);
              return true;
            })
          ]));
      log.info('test message');
    });

    test('should log warning message', () {
      final log = Trackit.create('test4');
      expectLater(
          Trackit.getInstance().stream,
          emitsInOrder([
            predicate<LogData>((msg) {
              expect(msg.message == 'test message', true);
              expect(msg.level == LogLevel.warning, true);
              expect(msg.title == 'test4', true);
              return true;
            })
          ]));
      log.warning('test message');
    });

    test('should log error message', () {
      final log = Trackit.create('test5');
      expectLater(
          Trackit.getInstance().stream,
          emitsInOrder([
            predicate<LogData>((msg) {
              expect(msg.message == 'test message', true);
              expect(msg.level == LogLevel.error, true);
              expect(msg.title == 'test5', true);
              return true;
            })
          ]));
      log.error('test message');
    });

    test('should log fatal message', () {
      final log = Trackit.create('test6');
      expectLater(
          Trackit.getInstance().stream,
          emitsInOrder([
            predicate<LogData>((msg) {
              expect(msg.message == 'test message', true);
              expect(msg.level == LogLevel.fatal, true);
              expect(msg.title == 'test6', true);
              return true;
            })
          ]));
      log.fatal('test message');
    });
  });
}
