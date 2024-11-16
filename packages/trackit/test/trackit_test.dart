import 'package:test/test.dart';
import 'package:trackit/trackit.dart';

void main() {
  group('Base logger tests', () {
    test('Instance title', () {
      final log = Trackit.create('test');
      expect(log.title == 'test', true);
    });

    test('Verbose LogData', () {
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

    test('Debug LogData', () {
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

    test('Info LogData', () {
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

    test('Warning LogData', () {
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

    test('Error LogData', () {
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

    test('Fatal LogData', () {
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
