import 'package:test/test.dart';
import 'package:trackit/trackit.dart';

class TestObserver extends TrackitObserver {
  String? lastMessage;
  String? lastFormatted;

  @override
  void log(LogData log, dynamic formatted) {
    lastMessage = log.message;
    lastFormatted = formatted;
  }
}

class TestFilter extends TrackitFilter {
  TestFilter({super.observers});

  @override
  bool allow(LogData data) {
    return true;
  }

  @override
  bool deny(LogData data) {
    return data.level == LogLevel.info;
  }
}

class TestFormatter extends TrackitFormatter {
  const TestFormatter({super.observers});

  @override
  dynamic format(LogData data, _) {
    return '[${data.level}] (${data.title}) ${data.message}';
  }
}

void main() {
  group('Observer tests', () {
    tearDown(() {
      Trackit.getInstance().clear();
    });

    test('Observer add get remove', () {
      Trackit.getInstance().add(TestObserver());
      var found = Trackit.getInstance().firstWhereType<TestObserver>();
      expect(found == null, false);
      expect(found is TestObserver, true);
      Trackit.getInstance().remove<TestObserver>();
      found = Trackit.getInstance().firstWhereType<TestObserver>();
      expect(found == null, true);
    });

    test('Observer handler', () {
      Trackit.getInstance().add(TestObserver());
      final log = Trackit.create('test7');
      log.info('test message');
      expect(
        (Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver)
            .lastMessage,
        'test message',
      );
    });

    test('Observer filter', () {
      Trackit.getInstance().add(TestFilter(observers: [TestObserver()]));
      final log = Trackit.create('test8');
      log.info('test message');
      expect(
        (Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver)
                .lastMessage ==
            'test message',
        false,
      );
      log.debug('test message');
      expect(
        (Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver)
                .lastMessage ==
            'test message',
        true,
      );
    });

    test('Observer formatter', () {
      Trackit.getInstance().add(TestFormatter(observers: [TestObserver()]));
      final log = Trackit.create('test9');
      log.info('test message');
      expect(
        (Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver)
            .lastFormatted,
        '[info] (test9) test message',
      );
    });
  });
}
