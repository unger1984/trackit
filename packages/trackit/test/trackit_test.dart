import 'package:test/test.dart';
import 'package:trackit/trackit.dart';

void main() {
  group('Trackit', () {
    test('Trackit instance creation', () {
      final log = Trackit.create('Test Instance');
      expect(log, isNotNull);
      expect(log.title, equals('Test Instance'));
    });

    test('Trackit logging', () {
      final log = Trackit.create('Test Instance');
      Trackit().listen(
        expectAsync1(
          (data) {
            expect(data.title, 'Test Instance');
            expect(data.message, 'Test log message');
            expect(data.level, equals(const LogLevel.trace()));
          },
        ),
      );
      log.log('Test log message');
    });
  });
}
