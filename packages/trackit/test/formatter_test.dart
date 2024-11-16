import 'package:test/test.dart';
import 'package:trackit/trackit.dart';

class TestObserver extends TrackitObserver {
  String? lastMessage;
  dynamic lastFormatted;

  @override
  void log(LogData log, dynamic formatted) {
    lastMessage = log.message;
    lastFormatted = formatted;
  }
}

void main() {
  group('Observer tests', () {
    tearDown(() {
      Trackit.getInstance().clear();
    });

    test('DefaultStringFormatter', () {
      Trackit.getInstance()
          .add(DefaultStringFormatter(observers: [TestObserver()]));
      final log = Trackit.create('test10');
      log.info('test message');
      final found =
          Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver;
      expect(found.lastFormatted, '[INFO] (test10) test message');
    });

    test('DefaultMapFormatter', () {
      Trackit.getInstance()
          .add(DefaultMapFormatter(observers: [TestObserver()]));
      final log = Trackit.create('test10');
      log.info('test message');
      final found =
          Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver;
      expect(
          found.lastFormatted
              ?.toString()
              .replaceFirst(RegExp(r'time: (.*),\sexception'), 'exception'),
          '{level: info, title: test10, exception: null, stackTrace: null}');
    });
  });
}
