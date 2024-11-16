import 'package:test/test.dart';
import 'package:trackit_print/trackit_print.dart';

class TestObserver extends TrackitObserver {
  String? lastMessage;
  String? lastFormatted;

  @override
  void log(LogData log, dynamic formatted) {
    lastMessage = log.message;
    lastFormatted = formatted;
  }
}

void main() {
  group('Test Trackit Print', () {
    tearDown(() {
      Trackit.getInstance().clear();
    });

    test('ColorFormatter', () {
      final log = Trackit.create('test1');
      Trackit.getInstance().add(ColorFormatter(observers: [TestObserver()]));
      log.info('test message');
      final found =
          Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver;
      expect(found.lastFormatted, '\x1B[38;5;2mtest message\x1B[0m');
    });

    test('ColorFormatter', () {
      final log = Trackit.create('test1');
      Trackit.getInstance().add(ColorBorderedFormatter(
        borderWidth: 1,
        withCorners: false,
        observers: [TestObserver()],
      ));
      log.info('test message');
      final found =
          Trackit.getInstance().firstWhereType<TestObserver>() as TestObserver;
      expect(
        found.lastFormatted,
        '\x1B[38;5;2m─\x1B[0m\n\x1B[38;5;2m│ test message\x1B[0m\n\x1B[38;5;2m─\x1B[0m',
      );
    });
  });
}
